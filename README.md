📄 Описание / Description

🐝 rl-swarm — это распределённая система агентов для обучения с подкреплением, с поддержкой телеметрии через OpenTelemetry.
Скрипт автоматизирует установку зависимостей, клонирование репозитория и запуск всех контейнеров через Docker Compose.

🐝 rl-swarm is a distributed reinforcement learning agent swarm with OpenTelemetry support.
This script automates installing dependencies, cloning the repository, and launching all containers via Docker Compose.

🚀 Установка / Installation

```git clone https://github.com/noderguru/Gensyn-Node-CPU_setup.git```

```cd Gensyn-Node-CPU_setup```

```chmod +x Gensyn-Node.sh && ./Gensyn-Node.sh```

📋 Просмотр логов / View logs

docker compose logs -f                # Все сервисы / All services
docker compose logs -f swarm_node     # Только swarm_node / only swarm_node container
docker compose logs -f otel-collector # Только otel-collector / only otel-collector container
docker compose logs -f fastapi        # Только fastapi / only fastapi  container




🔗 https://github.com/noderguru

