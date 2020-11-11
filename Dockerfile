FROM gableroux/unity3d:2020.1.12f1

LABEL "com.github.actions.name"="Unity Runner"
LABEL "com.github.actions.description"="Run unity any Unity project."
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="http://github.com/MirrorNG/unity-runner"
LABEL "homepage"="http://github.com/MirrorNG/unity-runner"
LABEL "maintainer"="Paul Pacheco <paulpach@gmail.com>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends default-jre && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt-get autoremove -y 
    
# install sonar scanner
RUN /opt/Unity/Editor/Data/NetCore/Sdk-2.2.107/dotnet tool install dotnet-sonarscanner --tool-path . --version 4.7.1

COPY unity_csc.sh.patch .
RUN patch /opt/Unity/Editor/Data/Tools/RoslynScripts/unity_csc.sh unity_csc.sh.patch

COPY entrypoint.sh activate.sh sonar-scanner.sh request_activation.sh /

ENV DOTNET_ROOT=/opt/Unity/Editor/Data/NetCore/Sdk-2.2.107/

RUN chmod +x /entrypoint.sh && \
    chmod +x /activate.sh && \
    chmod +x /request_activation.sh && \
    chmod +x /sonar-scanner.sh

ENTRYPOINT ["/entrypoint.sh"]
