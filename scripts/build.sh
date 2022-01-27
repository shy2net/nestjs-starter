#!/bin/bash

check_errcode() {
    status=$?

    if [ $status -ne 0 ]; then
        echo "${1}"
        exit $status
    fi
}

echo "Checking for missing dependencies before build..."

# Check if node_modules exists, if not throw an error
if [ ! -d "./node_modules" ]; then
    echo "node_modules are missing! running install script..."
    npm install
    echo "Installed all missing dependencies! starting installation..."
else
    echo "All dependencies are installed! Ready to run build!"
fi

# This script compiles typescript and Angular 7 application and puts them into a single NodeJS project
ENV=${NODE_ENV:-production}
echo -e "\n-- Started build script for NodeJS (environment $ENV) --"
echo "Removing dist directory..."
rm -rf dist

echo "Compiling typescript..."
./node_modules/.bin/tsc -p ./tsconfig.build.json
check_errcode "Failed to compile typescript! aborting script!"

echo "Copying essential files..."
bash ./scripts/copy-essentials.sh

check_errcode "Failed to copy essential files! aborting script!"

echo "-- Finished building NodeJS, check dist directory --"
