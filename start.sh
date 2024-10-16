#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

purgevenv() {
    rm -rf bin lib lib64 include pyvenv.cfg
}

echo
echo Starting IIOT to Sink
echo =====================

if [ "$1" == "--clean" ]; then
    echo -n Cleaning virtual environment...
    purgevenv
    echo OK
fi

echo -n "Checking environment..."
if command -v python3 >/dev/null 2>&1 ; then
    if [ ! -f $SCRIPT_DIR/config.yml ]; then
        echo FAIL!
        echo "config.yml not found! Review the readme to setup your environment"
        exit 2
    else
        echo "OK"
        echo -n "Loading configuration."
        if [ ! -f $SCRIPT_DIR/pyvenv.cfg ]; then
            cp $SCRIPT_DIR/.gitignore $SCRIPT_DIR/gitignore.bak
            python3 -m venv .
            mv $SCRIPT_DIR/gitignore.bak $SCRIPT_DIR/.gitignore
        fi
        echo -n "."
        source $SCRIPT_DIR/bin/activate
        echo ".OK"
        echo -n "Loading dependencies..."
        if $SCRIPT_DIR/bin/pip3 install -r $SCRIPT_DIR/requirements.txt --quiet; then
            echo OK
        else
            echo FAIL!
            echo "pip could not install requirements. Please try installing manually within the venv:"
            echo "bin/pip3 install -r requirements.txt"
            exit 3
        fi
        echo "Starting main loop..."
        $SCRIPT_DIR/bin/python3 $SCRIPT_DIR/start.py
    fi
else
    echo FAIL!
    echo "This tool requires Python3 and a venv for dependencies"
    exit 1
fi