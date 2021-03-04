FROM gableroux/unity3d:2020.1.12f1

LABEL "com.github.actions.name"="Unity Runner"
LABEL "com.github.actions.description"="Run unity any Unity project."
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="http://github.com/MirrorNG/unity-runner"
LABEL "homepage"="http://github.com/MirrorNG/unity-runner"
LABEL "maintainer"="Paul Pacheco <paulpach@gmail.com>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends default-jre unzip && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt-get autoremove -y 
    
# install sonar scanner
RUN /opt/Unity/Editor/Data/NetCore/Sdk-2.2.107/dotnet tool install dotnet-sonarscanner --tool-path . --version 4.7.1

COPY unity_csc.sh.patch .
RUN patch /opt/Unity/Editor/Data/Tools/RoslynScripts/unity_csc.sh unity_csc.sh.patch

# install mono
RUN apt install gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt install -y mono-devel

# install docfx
RUN wget https://github.com/dotnet/docfx/releases/download/v2.56.6/docfx.zip && \
    unzip docfx.zip -d /docfx && \
    rm docfx.zip


COPY entrypoint.sh activate.sh sonar-scanner.sh request_activation.sh docfx.sh /

ENV DOTNET_ROOT=/opt/Unity/Editor/Data/NetCore/Sdk-2.2.107/

RUN chmod +x /entrypoint.sh && \
    chmod +x /activate.sh && \
    chmod +x /request_activation.sh && \
    chmod +x /sonar-scanner.sh && \
    chmod +x /docfx.sh

ENTRYPOINT ["/entrypoint.sh"]
