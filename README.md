# docker-avr
-------

## Build instructions
```bash
docker build . -t noah95/amake
```

## Usage
```bash
# Make an alias to run the container and launch make
alias amake='docker run --rm -v "$(pwd):/src" -t noah95/amake'
# Change to the source directory
cd test/
# Run a build process
amake
```

## Using running container
```bash
# Start the container in the background
alias runamake='docker run --rm -d -v "$(pwd):/src" --entrypoint /bg.sh -t --name amake noah95/amake'
runamake
# Launch a build
alias amake='docker exec -t amake /run.sh'
cd test/
amake
# Stop the container
alias stopamake='docker stop amake'
stopamake
```

