FROM microsoft/dotnet:2.2-sdk-alpine AS builder
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY TestSvc/*.csproj ./TestSvc/
RUN dotnet restore

# copy everything else and build app
COPY TestSvc/. ./TestSvc/
WORKDIR /app/TestSvc

RUN dotnet publish -c Debug -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine AS runner
WORKDIR /app

# image sets the ASPNETCORE_URLS environment variable to http://+:80 
ENV ASPNETCORE_URLS=http://+:5000

COPY --from=builder /app/TestSvc/out ./
ENTRYPOINT ["dotnet", "TestSvc.dll"]
