FROM microsoft/dotnet
WORKDIR /var/tmp/testcore
COPY global.json global.json
COPY src src
COPY test test
WORKDIR /var/tmp/testcore/src/PrimeService
RUN dotnet restore
WORKDIR /var/tmp/testcore/test/PrimeServices.Tests
RUN dotnet restore
CMD dotnet test