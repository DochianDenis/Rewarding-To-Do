#!/bin/bash


#Test
#Test
#Test
#Test
#Test
#Test
#Test


# Creates the text file in which the sum of money will be stored in case it's not already created.
if [[ ! -e Money.txt ]]; then 
	touch Money.txt
	echo "0" > Money.txt
fi


# Creates the text file in which the tasks will be added in case it's not already created.
if [[ ! -e todo.txt ]]; then
	touch todo.txt
fi

if [[ ! -e rewards.txt ]]; then 
	touch rewards.txt
fi

case "$1" in
	reset)
    	echo "0" > Money.txt
    	echo "Money.txt has been reset."
   	;;

   	tasks)
		if [[ -n todo.txt ]]; then
			cat todo.txt
		else
			echo "You have 0 tasks for the moment."
		fi
	;;

	add)
		if [[ -n "$4" ]]; then
		echo "Can't add more than one task at a time."
		else
			if [[ -n "$2" ]]; then
				if [[ -n "$3" ]]; then
						line_number=$(( $(wc -l < todo.txt) + 1))
						echo "$line_number.$2 - reward - $3 " >> todo.txt
						echo "$2 was added."
				else
					echo "The reward was not specified."
				fi
			else
				echo "The name of the task was not specified."
			fi
		fi
	;;

	deleteall)
		> todo.txt
	;;

	help)
echo "reset - Resets how much money you have obtained.
tasks - Shows all tasks
add x y - Adds the x task with the reward y.
deleteall - Deletes all tasks
done x - Deletes the task x(the number of the task in the file) and adds its reward to your money file.
rewards - Shows all rewards
addreward x y - Adds the reward x with the price of you
buy x - Reduces your money by the price of reward x(the number of the reward in the file)
deleteallrewards - Deletes all of the rewards"
	;;

	done)
		if [[ -n $2 ]]; then
			if [[ $2 =~ ^[0-9]+$ ]]; then
				read -r money < Money.txt
				read -r reward <<< "$(sed -n "$2p" todo.txt | awk '{print $NF}')"
				if [[ "$reward" -eq 0 ]];then 
					echo "The task does not exists."
					cat todo.txt
				fi
				money=$((money+reward))
				echo "$money" > money.txt
				echo "$reward money were added.
You now have $money."
				sed -i '' "$2d" todo.txt
				awk '{$1=NR"."; print}' todo.txt > temp.txt && mv temp.txt todo.txt
			else
				echo "You have to input the number of the task you wish to mark as done."
				cat todo.txt
			fi
		else
			echo "You haven't selected a task.The tasks are:"
			cat todo.txt
		fi
	;;

	rewards)
		cat rewards.txt
	;;

	addreward)
		if [[ -n $4 ]]; then
			echo "You can't add more than one reward at a time."
		else
			if [[ -n $2 ]]; then
				if [[ -n $3 ]]; then
					if [[ $3 =~ ^[0-9]+$ ]]; then 
						line_number=$(( $(wc -l < rewards.txt) + 1))
						echo "$line_number.$2 - price - $3 " >> rewards.txt
						echo "$2 was added."
					else
						echo "The reward has to be a natural number."
					fi
				else
					echo "Please add a reward."
				fi
			else
				echo "No reward was added."
			fi
		fi
	;;

	buy)
		if [[ -n $2 ]]; then
			if [[ $2 =~ ^[0-9]+$ ]]; then
				read -r money < Money.txt
				read -r price <<< "$(sed -n "$2p" rewards.txt | awk '{print $NF}')"
				if [[ "$price" -eq 0 ]];then
					echo "The reward does not exists."
					cat rewards.txt
				else
					if [[ "$money" -gt "$price" ]]; then
						money=$((money-price))
						echo "$money" > money.txt
						echo "You have $money left."
					else
						echo "You can't buy the item because you do not have enough money."
					fi
				fi
			else
				echo "You have to input the number of the item you want to buy."
				cat rewards.txt
			fi
		else
			echo "You haven't selected a task.The tasks are:"
			cat todo.txt
		fi
	;;

	deleteallrewards)
		> rewards.txt
	;;

	money)
		cat Money.txt
	;;

	*)
	echo "You haven't selected any valid options.
For more information type $0 help"
esac
