################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Source_Code/LogicLayer/PLLogicLayer.cpp 

OBJS += \
./Source_Code/LogicLayer/PLLogicLayer.o 

CPP_DEPS += \
./Source_Code/LogicLayer/PLLogicLayer.d 


# Each subdirectory must supply rules for building sources it contributes
Source_Code/LogicLayer/%.o: ../Source_Code/LogicLayer/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I/usr/include/ -I/usr/local/include -I/usr/include/c++/4.4.4 -I/usr/lib/gcc/x86_64-redhat-linux/4.4.4/include -I/usr/include/c++/4.4.4/x86_64-redhat-linux -I/usr/include/c++/4.4.4/backward -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


