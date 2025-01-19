#!/bin/bash

# Function to ask user for input with validation and optional default value
ask_question() {
    local prompt="$1"
    local default="$2"
    local response

    while true; do
        if [[ -n $default ]]; then
            echo -n "$prompt [$default]: "
        else
            echo -n "$prompt: "
        fi
        read -r response
        response="${response:-$default}"

        if [[ -n $response ]]; then
            echo "$response"
            break
        else
            echo "Input cannot be empty. Please try again."
        fi
    done
}

# Function to offer a template for common roles
offer_templates() {
    echo "Available templates:"
    echo "1. Culinary Innovator"
    echo "2. Travel Planner"
    echo "3. Code Assistant"
    echo "4. Fitness Coach"
    echo "5. Career Advisor"
    echo "6. Custom (you define everything)"
    echo -n "Choose a template (1-6): "
    read -r template_choice

    case $template_choice in
        1)
            echo "Culinary Innovator" \
                 "developing recipes" \
                 "transform ingredients into creative, flavorful dishes" \
                 "tips for substitutions, dietary accommodations, and presentation"
            ;;
        2)
            echo "Travel Planner" \
                 "creating travel plans" \
                 "design itineraries for exciting destinations" \
                 "budget optimization, transportation tips, and cultural advice"
            ;;
        3)
            echo "Code Assistant" \
                 "debugging and writing code" \
                 "solve programming problems and provide explanations" \
                 "best practices, examples, and optimization tips"
            ;;
        4)
            echo "Fitness Coach" \
                 "creating personalized fitness plans" \
                 "help users achieve their health and fitness goals" \
                 "exercise modifications, progress tracking, and motivational advice"
            ;;
        5)
            echo "Career Advisor" \
                 "offering professional development guidance" \
                 "help users create résumés, prepare for interviews, and plan their careers" \
                 "industry insights, networking tips, and personalized action plans"
            ;;
        6)
            echo ""
            ;;
        *)
            echo "Invalid choice. Defaulting to Custom."
            echo ""
            ;;
    esac
}

# Initialize outputs directory
outputs_dir="outputs"
mkdir -p "$outputs_dir"

# Start the script
echo "Welcome to the Enhanced Prompt Generator!"
echo "Would you like to use a predefined template or create a custom prompt?"
template_data=$(offer_templates)
if [[ -n $template_data ]]; then
    IFS=" " read -r role specialization objectives additional_services <<< "$template_data"
else
    role=$(ask_question "What is the role or expertise of the system" "")
    specialization=$(ask_question "What is the system's specialization" "")
    objectives=$(ask_question "What is the main role of the system" "")
    additional_services=$(ask_question "What additional services should the system provide" "")
fi

# Collect remaining details
context=$(ask_question "What is the context or goal for the prompt" "")
instructions=$(ask_question "Provide step-by-step instructions for the system" "1. Ask for inputs, 2. Provide a solution.")
constraints=$(ask_question "What constraints should the system follow" "Use accessible options and tailor to user needs.")
output_format=$(ask_question "What should the output format look like" "Structured sections with clear labels.")
reasoning=$(ask_question "What reasoning approach should the system use" "Creative thinking and logical problem-solving.")
user_input=$(ask_question "What should the system ask the user to begin the process" "Please provide [relevant details] to get started.")

# Generate the prompt
prompt_output=$(cat <<EOL
<System>
You are a $role specializing in $specialization. Your role is to $objectives. Additionally, you provide $additional_services.
</System>

<Context>
$context
</Context>

<Instructions>
$instructions
</Instructions>

<Constraints>
$constraints
</Constraints>

<Output Format>
$output_format
</Output Format>

<Reasoning>
$reasoning
</Reasoning>

<User Input>
Reply with: "$user_input"
</User Input>
EOL
)

# Save the prompt to the outputs directory
timestamp=$(date +"%Y%m%d_%H%M%S")
output_file="$outputs_dir/prompt_$timestamp.txt"
echo "$prompt_output" > "$output_file"

# Display the generated prompt
echo
echo "Here is your generated prompt:"
echo "--------------------------------------------------"
echo "$prompt_output"
echo "--------------------------------------------------"
echo "Prompt saved to $output_file"

# Completion message
echo "Prompt generation complete! Copy and paste the above or use the saved file."
