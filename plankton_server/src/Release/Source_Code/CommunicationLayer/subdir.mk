################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Source_Code/CommunicationLayer/CMLPackage.cpp \
../Source_Code/CommunicationLayer/CMLSession.cpp \
../Source_Code/CommunicationLayer/CMLSessionPool.cpp \
../Source_Code/CommunicationLayer/PLCommunicationLayer.cpp 

OBJS += \
./Source_Code/CommunicationLayer/CMLPackage.o \
./Source_Code/CommunicationLayer/CMLSession.o \
./Source_Code/CommunicationLayer/CMLSessionPool.o \
./Source_Code/CommunicationLayer/PLCommunicationLayer.o 

CPP_DEPS += \
./Source_Code/CommunicationLayer/CMLPackage.d \
./Source_Code/CommunicationLayer/CMLSession.d \
./Source_Code/CommunicationLayer/CMLSessionPool.d \
./Source_Code/CommunicationLayer/PLCommunicationLayer.d 


# Each subdirectory must supply rules for building sources it contributes
Source_Code/CommunicationLayer/%.o: ../Source_Code/CommunicationLayer/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


