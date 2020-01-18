# Build Stage
FROM mcr.microsoft.com/dotnet/core/sdk:2.1.803-bionic AS build-env
WORKDIR /api

COPY api.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -o /publish

# Runtime Image Stage
FROM microsoft/aspnetcore:2
WORKDIR /publish
COPY --from=build-env /publish .
ENTRYPOINT ["dotnet", "api.dll"]