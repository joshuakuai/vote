################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Source_Code/Lib/json_reader.cpp \
../Source_Code/Lib/json_value.cpp \
../Source_Code/Lib/json_writer.cpp 

OBJS += \
./Source_Code/Lib/json_reader.o \
./Source_Code/Lib/json_value.o \
./Source_Code/Lib/json_writer.o 

CPP_DEPS += \
./Source_Code/Lib/json_reader.d \
./Source_Code/Lib/json_value.d \
./Source_Code/Lib/json_writer.d 


# Each subdirectory must supply rules for building sources it contributes
Source_Code/Lib/%.o: ../Source_Code/Lib/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I/usr/include/ -I/usr/local/include -I/usr/include/c++/4.4.4 -I/usr/lib/gcc/x86_64-redhat-linux/4.4.4/include -I/usr/include/c++/4.4.4/x86_64-redhat-linux -I/usr/include/c++/4.4.4/backward -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


