# NSS-Practica8-Ansible

**Práctica 8 de Electiva 2 (DevOps) - ITLA**

Hecha por Nicole Alejandra Santana Sánchez, matrícula 2025-1213.

Profesor: Elvis Cruz.

## ¿De qué trata?

De automatizar tareas en varios servidores a la vez con **Ansible**. Como no tenemos servidores en la nube, levanto **5 servidores Ubuntu** con Docker y Ansible entra a cada uno por SSH.

## ¿Cómo está organizado?

```
NSS-Practica8-Ansible/
├── Dockerfile          → la imagen de Ubuntu con SSH y el usuario ansible
├── docker-compose.yml  → los 5 servidores
├── inventario.ini      → la lista de servidores para Ansible
├── ansible.cfg         → la configuración de Ansible
├── playbook.yml        → las tareas de la práctica
├── verificar.yml       → comprueba que todo quedó bien
└── README.md
```

## Los archivos

- **Dockerfile:** parte de `ubuntu:24.04` e instala `openssh-server`, `sudo` y `python3` (Ansible lo necesita en cada servidor). Crea el usuario `ansible` con clave `ansible` y le da sudo sin password.
- **docker-compose.yml:** levanta 5 servidores con esa imagen. Cada uno tiene su propio puerto SSH, del `2201` al `2205`. Al principio usé del 2221 al 2225, pero el `2222` ya lo usa Codespaces, así que me dio error y los cambié.
- **inventario.ini:** los 5 servidores con su IP (`127.0.0.1`), su puerto, y el usuario y la clave `ansible`.
- **ansible.cfg:** le dice a Ansible dónde está el inventario y que no pregunte por la huella SSH de cada servidor.

## ¿Qué hace el playbook.yml?

En los 5 servidores a la vez:

1. Actualiza la caché de APT.
2. Crea el usuario `itla`.
3. Crea la carpeta `/app`.
4. Crea el archivo `/app/hola.txt`, con el nombre de cada servidor adentro.
5. Instala `cowsay` y `htop`.

## Lo extra

- **El ping:** antes de los playbooks, comprobé que Ansible llegaba a los 5 servidores con `ansible servidores -m ping`. Todos contestaron `pong`.
- **El verificar.yml:** revisa en cada servidor el usuario `itla`, lee el `hola.txt`, muestra la versión de `htop` y pone a la vaquita de `cowsay` a saludar.
- **Idempotencia:** corrí el `playbook.yml` dos veces. La segunda vez casi todo salió `ok` con `changed=0`, porque Ansible revisa antes de actuar: si el usuario ya existe o el programa ya está instalado, no lo vuelve a hacer. Así se puede correr las veces que haga falta sin romper nada.

## ¿Cómo lo corro?

```bash
docker compose up -d --build       # construye la imagen y levanta los 5 servidores
docker ps                          # muestra los 5 servidores encendidos
sudo apt-get install -y ansible sshpass   # instala Ansible y sshpass
ansible servidores -m ping         # comprueba que Ansible llega a los 5
ansible-playbook playbook.yml      # hace las tareas de la práctica
ansible-playbook verificar.yml     # comprueba que todo quedó bien
docker compose down                # apaga los servidores
```

## ¿Dónde lo probé?

En **GitHub Codespaces**, porque mi disco no tiene espacio para Docker Desktop. Como Codespaces ya es Linux, no tuve que instalar WSL, e instalé Ansible directo con `apt`.