R Integração do Módulo Competições - Guia de Uso

Este documento descreve como usar os services e providers criados para o módulo Competições.

## Estrutura Criada

### Models
- `lib/core/models/competition.dart` - Models para competições, distâncias, lotes, patrocinadores, documentos e inscrições
- `lib/core/models/run.dart` - Models para corridas, eventos e ranking

### Services
- `lib/core/services/competition_service.dart` - Operações relacionadas a competições
- `lib/core/services/run_service.dart` - Operações relacionadas a corridas

### Providers
- `lib/core/providers/competition_provider.dart` - Providers Riverpod para competições
- `lib/core/providers/run_provider.dart` - Providers Riverpod para corridas

## Exemplos de Uso

### 1. Listar Competições

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/competition_provider.dart';
import '../core/models/competition.dart';

class CompetitionsListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competitionsAsync = ref.watch(
      competitionsProvider(
        CompetitionListParams(status: CompetitionStatus.open),
      ),
    );

    return competitionsAsync.when(
      data: (competitions) => ListView.builder(
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];
          return ListTile(
            title: Text(competition.title),
            subtitle: Text(competition.locationName ?? ''),
            onTap: () {
              context.push('/competitions/${competition.id}');
            },
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}
```

### 2. Detalhes de uma Competição

```dart
class CompetitionDetailPage extends ConsumerWidget {
  final String competitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competitionAsync = ref.watch(competitionProvider(competitionId));
    final distancesAsync = ref.watch(competitionDistancesProvider(competitionId));
    final lotsAsync = ref.watch(competitionLotsProvider(competitionId));
    final isRegisteredAsync = ref.watch(userIsRegisteredProvider(competitionId));

    return competitionAsync.when(
      data: (competition) {
        if (competition == null) {
          return Text('Competição não encontrada');
        }
        return Scaffold(
          appBar: AppBar(title: Text(competition.title)),
          body: Column(
            children: [
              // Exibir detalhes
              Text(competition.description ?? ''),
              // Listar distâncias
              distancesAsync.when(
                data: (distances) => ...,
                loading: () => CircularProgressIndicator(),
                error: (e, s) => Text('Erro: $e'),
              ),
              // Botão de inscrição
              isRegisteredAsync.when(
                data: (isRegistered) {
                  if (isRegistered) {
                    return Text('Você já está inscrito');
                  }
                  return ElevatedButton(
                    onPressed: () => _showRegistrationDialog(context, ref),
                    child: Text('Inscrever-se'),
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (e, s) => Text('Erro: $e'),
              ),
            ],
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}
```

### 3. Criar Inscrição

```dart
Future<void> createRegistration(
  BuildContext context,
  WidgetRef ref, {
  required String competitionId,
  required String distanceId,
  required String lotId,
}) async {
  final service = ref.read(competitionServiceProvider);
  
  try {
    final registration = await service.createRegistration(
      competitionId: competitionId,
      distanceId: distanceId,
      lotId: lotId,
      acceptedTerms: true,
    );
    
    // Invalidar providers para atualizar UI
    ref.invalidate(userIsRegisteredProvider(competitionId));
    ref.invalidate(userRegistrationProvider(competitionId));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inscrição realizada com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}
```

### 4. Iniciar Corrida

```dart
Future<void> startRun(
  BuildContext context,
  WidgetRef ref, {
  required String competitionId,
  String? registrationId,
}) async {
  final runService = ref.read(runServiceProvider);
  
  try {
    // Criar corrida
    final run = await runService.createRun(
      competitionId: competitionId,
      registrationId: registrationId,
    );
    
    // Iniciar corrida
    await runService.startRun(run.id);
    
    // Navegar para tela de corrida
    context.push('/runs/${run.id}');
    
    // Invalidar providers
    ref.invalidate(userRunsProvider(UserRunsParams(competitionId: competitionId)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao iniciar corrida: $e')),
    );
  }
}
```

### 5. Gerenciar Estado da Corrida

```dart
class RunPage extends ConsumerStatefulWidget {
  final String runId;

  @override
  ConsumerState<RunPage> createState() => _RunPageState();
}

class _RunPageState extends ConsumerState<RunPage> {
  @override
  Widget build(BuildContext context) {
    final runAsync = ref.watch(runProvider(widget.runId));
    
    return runAsync.when(
      data: (run) {
        if (run == null) {
          return Text('Corrida não encontrada');
        }
        
        return Scaffold(
          body: Column(
            children: [
              Text('Tempo: ${run.formattedTotalTime}'),
              Text('Distância: ${run.formattedDistance}'),
              if (run.isRunning)
                ElevatedButton(
                  onPressed: () => _pauseRun(run.id),
                  child: Text('Pausar'),
                )
              else if (run.isPaused)
                ElevatedButton(
                  onPressed: () => _resumeRun(run.id),
                  child: Text('Retomar'),
                ),
              ElevatedButton(
                onPressed: () => _finishRun(run.id),
                child: Text('Finalizar'),
              ),
            ],
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Erro: $e'),
    );
  }
  
  Future<void> _pauseRun(String runId) async {
    final service = ref.read(runServiceProvider);
    await service.pauseRun(runId);
    ref.invalidate(runProvider(runId));
  }
  
  Future<void> _resumeRun(String runId) async {
    final service = ref.read(runServiceProvider);
    await service.resumeRun(runId);
    ref.invalidate(runProvider(runId));
  }
  
  Future<void> _finishRun(String runId) async {
    final service = ref.read(runServiceProvider);
    // Calcular métricas (exemplo)
    await service.finishRun(
      runId,
      totalTimeSeconds: 3600, // 1 hora
      distanceMeters: 10000, // 10km
      avgPaceSecondsPerKm: 360, // 6 min/km
    );
    ref.invalidate(runProvider(runId));
  }
}
```

### 6. Exibir Ranking

```dart
class LeaderboardPage extends ConsumerWidget {
  final String competitionId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(
      competitionLeaderboardProvider(
        LeaderboardParams(competitionId: competitionId),
      ),
    );
    
    return leaderboardAsync.when(
      data: (entries) => ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            leading: Text('#${entry.rank}'),
            title: Text(entry.userName ?? 'Anônimo'),
            subtitle: Text(entry.formattedTotalTime),
            trailing: Text(entry.formattedPace ?? ''),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Erro: $e'),
    );
  }
}
```

## Rotas Sugeridas

Adicione estas rotas ao `lib/app/router.dart`:

```dart
GoRoute(
  path: '/competitions',
  name: 'competitions',
  builder: (context, state) => const CompetitionsListPage(),
),
GoRoute(
  path: '/competitions/:id',
  name: 'competition-detail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return CompetitionDetailPage(competitionId: id);
  },
),
GoRoute(
  path: '/runs/:id',
  name: 'run',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return RunPage(runId: id);
  },
),
GoRoute(
  path: '/competitions/:id/leaderboard',
  name: 'leaderboard',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return LeaderboardPage(competitionId: id);
  },
),
```

## Próximos Passos

1. Criar as telas de UI conforme o design
2. Conectar os providers aos widgets
3. Implementar fluxo completo: listagem → detalhe → inscrição → corrida → resultado
4. Adicionar tratamento de erros e loading states
5. Implementar refresh/pull-to-refresh onde necessário
