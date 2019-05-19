#!/bin/bash

echo "$(sudo gcc -c phys_to_virt.c)"

echo "$(sudo as -o ControlStepper.o ControlStepper.s rutinas.s Physics.s gpio0_2.s -g)"

echo "$(sudo gcc -o ControlStepper ControlStepper.o phys_to_virt.o)"

