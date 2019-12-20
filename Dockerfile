FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS builder
ARG DOTNET_CONFIG=Release
COPY KafkaHealthCheck /src
RUN set -x \
 && dotnet restore \
 && dotnet build "./src/KafkaHealthCheck.csproj" -c ${DOTNET_CONFIG} -o /app \
 && dotnet publish "./src/KafkaHealthCheck.csproj" -c ${DOTNET_CONFIG} -o /app -nowarn:cs1591

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim
ENV ASPNETCORE_ENVIRONMENT=Development
WORKDIR /app
COPY --from=builder /app .

ENTRYPOINT ["dotnet", "KafkaHealthCheck.dll"]