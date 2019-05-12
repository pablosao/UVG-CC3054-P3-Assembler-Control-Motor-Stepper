#!/bin/bash

echo "$(sudo gcc -c phys_to_virt.c)"

echo "$(sudo as -o ControlStepper.o ControlStepper.s -g)"

echo "$(sudo gcc -o ControlStepper ControlStepper.o phys_to_virt.o)"

