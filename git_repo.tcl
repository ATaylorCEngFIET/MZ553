
# Function to get the current short commit ID from Git
proc get_short_git_commit_id {} {
    set git_command "git rev-parse --short HEAD"
    set result [catch {exec git rev-parse --short HEAD} commit_id]
    if {$result == 0} {
        return [format "%08s" $commit_id]
    } else {
        return "ERROR";  # Default or error code if git command fails
    }
}

# Function to insert or update a signal in the VHDL file
proc update_or_insert_signal {file_path commit_id} {
    # Read the content of the VHDL file
    set f [open $file_path r]
    set file_data [split [read $f] "\n"]
    close $f

    # Initialize a list to hold the new file content and a flag for insertion
    set new_file_data {}
    set found 0

    # Define the new signal line with the formatted Git commit
    set new_signal "signal version : std_logic_vector(31 downto 0) := x\"$commit_id\"; -- New version signal based on Git commit"

    # Check if the line already exists and needs updating
    foreach line $file_data {
        if {[string match "*signal version : std_logic_vector(31 downto 0) := x*\";$line} {
            lappend new_file_data $new_signal
            set found 1
        } else {
            lappend new_file_data $line
        }
    }

    # If the signal was not found and updated, add it to the end
    if {$found == 0} {
        lappend new_file_data $new_signal
    }

    # Write the modified content back to the VHDL file
    set f [open $file_path w]
    foreach line $new_file_data {
        puts $f $line
    }
    close $f

    puts "VHDL file has been updated or new signal has been added in $file_path"
}
# Main execution

set current_project [get_property DIRECTORY [current_project]]
cd $current_project
set vhdl_file_name "git_demo.srcs/sources_1/imports/new/version_reg.vhd"
set vhdl_file_path "$current_project/$vhdl_file_name"
set commit_id [get_short_git_commit_id]

# Check for error before proceeding
if {$commit_id == "ERROR"} {
    puts "Failed to retrieve Git commit ID."
} else {
    insert_new_signal $vhdl_file_path $commit_id
    puts "VHDL file updated with new register default value: $commit_id"
}
