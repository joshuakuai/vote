################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Source_Code/Common/PLog.cpp 

OBJS += \
./Source_Code/Common/PLog.o 

CPP_DEPS += \
./Source_Code/Common/PLog.d 


# Each subdirectory must supply rules for building sources it contributes
Source_Code/Common/%.o: ../Source_Code/Common/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


