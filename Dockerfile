FROM debian:latest

WORKDIR /mc_server
COPY server_files /mc_server

RUN apt-get update && apt-get install -y \
  ca-certificates \
  apt-transport-https \
  gnupg \ 
  wget \
  git
# Setting up to Amazon Corretto public key
RUN wget -O - https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | tee /etc/apt/sources.list.d/corretto.list
# Install java now that correto set up
RUN apt-get update && apt-get install -y \
  java-21-amazon-corretto-jdk \
  libxi6 \
  libxtst6 \
  libxrender1
# Some clean up
RUN rm -rf /var/lib/apt/lists/*

RUN addgroup --gid 1001 --system mc_server
RUN useradd -ms /bin/bash -u 1001 -g 1001 mc_server
RUN chown -R mc_server:mc_server /mc_server
RUN chmod u+x /mc_server/server.jar

# minecraft port
EXPOSE 25565
# minecraft rcon port
EXPOSE 25575
# simple voice chat plugin default udp port
EXPOSE 24454
# dynmap website default port
EXPOSE 8123

USER 1001
ENTRYPOINT ["java", "-Xms12G", "-Xmx12G", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1NewSizePercent=30", "-XX:G1MaxNewSizePercent=40", "-XX:G1HeapRegionSize=8M", "-XX:G1ReservePercent=20", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-Dusing.aikars.flags=https://mcflags.emc.gs", "-Daikars.new.flags=true", "-jar", "server.jar", "--nogui"]
CMD []
