##############################
# Basic Functional Functions #
##############################

# # Example transformation function
# square() {
#   local input=$1
#   echo "$((input * input))"
# }
# 
# declare -a my_list=(1 2 3 4 5)
# mapped_list=$(map my_list square)
# 
# # Display the result
# echo "Original list: ${my_list[@]}"
# echo "Transformed list: ${mapped_list[@]}"
# 
# # Output: Original list: 1 2 3 4 5
# # Output: Transformed list: 1 4 9 16 25
function map() {
  local -r transform_fn=$1
  local -n input_list=$2

  local mapped_list=()
  for element in "${input_list[@]}"; do
    mapped_list+=("$("$transform_fn" "$element")")
  done
  return "${mapped_list[@]}"
}

# `filter`
# Description:
#   filter function
# Input:
#   predicate (x: T, y: T) => T : binary operator
#   element T[] : Array of T
# Output:
#   T[]
# Example:
# # Example filtering function
# function is_even() {
#   local input=$1
#   ((input % 2 == 0))
# }
# 
# declare -a my_list=(1 2 3 4 5)
# filtered_list=$(filter is_even my_list)
# 
# # Display the result
# echo "Original list: ${my_list[@]}"
# echo "Filtered list (even elements): ${filtered_list[@]}"
# # Output: Original list: 1 2 3 4 5
# # Output: Filtered list (even elements): 2 4
function filter() {
  local -r predicate=$1
  local -n input_list=$2

  local filtered_list=()
  for element in "${input_list[@]}"; do
    if "$predicate" "$element"; then
      filtered_list+=("$element")
    fi
  done

  echo "${filtered_list[@]}"
}

# `zip`
# Description:
#   aggregation function
# Input:
#   accumulator (x: T, y: T) => T : binary operator
#   element T[] : Array of T
# Output:
#   T[]
# Example:
#   ```bash
#   sum() {
#     local accumulator=$1
#     local element=$2
#     echo "$((accumulator + element))"
#   }
#   
#   declare -a my_list=(1 2 3 4 5)
#   result=$(reduce my_list sum 0)
#   
#   # Display the result
#   echo "Original list: ${my_list[@]}"
#   echo "Reduction result (sum): $result"
#   
#   # Output: Original list: 1 2 3 4 5
#   # Output: Reduction result (sum): 15
#   ```
function zip() {
  local -n input_list1=$1
  local -n input_list2=$2

  local zipped_list=()
  local length=${#input_list1[@]}

  for ((i=0; i<length; i++)); do
    zipped_list+=("${input_list1[$i]},${input_list2[$i]}")
  done

  echo "${zipped_list[@]}"
}

##############
# Predicates #
##############
function installed() {
    return $(type ${1} &> /dev/null)
}

function not_installed() {
    return $(! type ${1} &> /dev/null)
}


