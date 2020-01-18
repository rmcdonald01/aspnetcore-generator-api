# Build stage
FROM mcr.microsoft.com/dotnet/core/sdk:2.1.803-bionic AS build-env

WORKDIR /generator

# restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# copy src
COPY . .

# Set the flag to tell TeamCity that these are unit tests:
ENV TEAMCITY_PROJECT_NAME = ${TEAMCITY_PROJECT_NAME}
# test
#ENV TEAMCITY_PROJECT_NAME=fake
RUN dotnet test tests/tests.csproj --verbosity=normal

# publish
RUN dotnet publish api/api.csproj -o /publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/core/runtime:2.1.15-bionic
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]