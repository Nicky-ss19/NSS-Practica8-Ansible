# Mi imagen de servidor para la Práctica 8: Ubuntu con SSH y el usuario ansible

# Parto de la imagen oficial de Ubuntu
FROM ubuntu:24.04

# Instalo el servidor SSH (para que Ansible se pueda conectar),
# sudo (para los permisos de administrador) y python3 (Ansible lo necesita en cada servidor)
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 && \
    rm -rf /var/lib/apt/lists/*

# Creo el usuario ansible, con clave ansible, y lo meto al grupo sudo
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:ansible' | chpasswd && \
    usermod -aG sudo ansible

# Le doy permiso de usar sudo sin pedirle la clave cada vez
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && \
    chmod 440 /etc/sudoers.d/ansible

# Preparo SSH: creo la carpeta que necesita y dejo entrar con usuario y clave
RUN mkdir -p /run/sshd && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# SSH escucha en el puerto 22
EXPOSE 22

# Cuando el contenedor arranca, enciende el servidor SSH y se queda corriendo
CMD ["/usr/sbin/sshd", "-D"]