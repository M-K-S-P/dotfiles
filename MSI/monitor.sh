#!/bin/bash

# Display name (e.g., eDP for laptop's built-in screen)
display="eDP"

# Function to change refresh rate using xrandr
set_refresh_rate() {
    local refresh_rate="$1"
    xrandr --output "$display" --mode 1920x1080 --rate "$refresh_rate"
}

# Function to check if the laptop is plugged in or running on battery
check_power_status() {
    # Check if the system is plugged into AC power
    if [ -f /sys/class/power_supply/ADP1/online ]; then
        # If the AC status file exists, check its content
        if [ "$(cat /sys/class/power_supply/ADP1/online)" -eq 1 ]; then
            echo "Laptop is connected to the charger (AC power)."
            set_refresh_rate 144
        else
            echo "Laptop is running on battery."
            set_refresh_rate 48
        fi
    elif [ -f /sys/class/power_supply/BAT1/status ]; then
        # Fallback check using BAT0 status file
        if grep -q "Charging" /sys/class/power_supply/BAT1/status; then
            echo "Laptop is connected to the charger."
            set_refresh_rate 144
        else
            echo "Laptop is running on battery."
            set_refresh_rate 48
        fi
    else
        echo "Unable to determine power status."
    fi
}

# Initially set the refresh rate based on charger status at the start
check_power_status

# Monitor the power status continuously (every 5 seconds in this case)
while true; do
    sleep 5
    check_power_status
done

