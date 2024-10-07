clc
clear

%Sets variables/game components:

%Game set
numObjectsPerStage = 3;
numComponentCategories = 4;
endingNumber = 0;
userInventory = ["Empty Weapon Slot", "Empty Item Slot", "Empty Item Slot"];
%Battle Based, Weapons, Health, etc (Inventory slot 1).
userHealth = 100;
userBaseDamage = 5;%
userCurrentDamage = userBaseDamage;
weaponNames = ["Weak Brioche Baton", "Medium Burnt Baguette Bat", "Strong Whole Wheat Whip", "Weak Brioche Baton" ...
               "Weak Brioche Baton", "Medium Burnt Baguette Bat", "Weak Brioche Baton", "Weak Brioche Baton" ...
               "Weak Brioche Baton", "Weak Brioche Baton", "Legendary Gold Plated Costa Del Sol Sword", "Weak Brioche Baton" ...
               "Weak Brioche Baton", "Weak Brioche Baton", "Strong Whole Wheat Whip", "Weak Brioche Baton", ]';
weaponDamage = [5, 10, 50, 5 ...
                5, 10, 5, 5 ...
                5, 10, 120, 5, ...
                5, 5, 50, 5]'; %Gets added to userBaseDamage
weaponPrices = [60, 200, 600, 60 ...
                60, 200, 60, 60 ...
                60, 200, 2000, 60 ...
                60, 60, 600, 60]';
weaponList = [weaponNames, weaponDamage, weaponPrices];
%Sales/loot based
goldLoaves = 10;
salesContents = ["Potion", "Big Potion"];
fieldItems = ["Potion", "Wheat Amulet", "China Bread Bowl", "Golden Bread Clip", "Silk Oven Mitts" ... 
              "Golden Brown Bread Crust", "Extra Virgin Olive Oil Bottle", "Rare Oven Parts", "Iron Tray", "Ball of Tin Foil"];
fieldItemPrices = [30, 40, 50, 60, 50 ...
                   35, 100, 70, 25, 20];
%Category based
npcType = ["Traveller", "Magician", "Bandit", "Storyteller"]';
miscType = ["Strange Rock", "Interesting Tree", "Peculiar Sign", "Downed Structure"]';
lootType = ["Chest", "Pile of Rubbish", "Sac of Loot", "Abandoned Wagon"]';
enemyType = ["Toaster", "Pack of Cutting Boards", "Bread Knife", "Butter Knife"]';
categoryMatrix = [npcType, miscType, lootType, enemyType];
%Outcome based
outcomeNpc = ["The individual murmured something unintelligible...", """Hey, you should really walk away right now.""", """You look like you are a long way from home traveller.""", """I used to be an adventurer like you.""", """It has been quite dangerous out here traveller. Take this with you.""" ... 
              """That damned hag. Always on my case about something!""", """You're a strange looking fellow, aren't ya!""", """Forget about it! No handouts for you...""", """...""", """Oh joy! A fellow traveller! Here, take this!""" ...
              """You seem hungry. Or maybe that's me?""", """Ah, you have that look in your eye traveller.""", """What are you looking at?""", """What is it that you need?""", """Quickly, take this and run away from here!"""]; %Dialogue, random drop (using mod(x, 5))
outcomeMisc = ["You rummage around and find some gold loaves!", "While investigating, you find some gold loaves!", "Your investigate yields gold loaves!", "You find some gold loaves!", "There is something shiny lodged in an oddly shaped crevice." ... 
               "You rummage around and find some gold loaves!", "While investigating, you find some gold loaves!", "Your investigate yields gold loaves!", "You find some gold loaves!", "A glimpse of a shiny reflection catches your eye." ...
               "You rummage around and find some gold loaves!", "While investigating, you find some gold loaves!", "Your investigate yields gold loaves!", "You find some gold loaves!", "You catch a shiny glimmer in the corner of your eye."]; %Dialogue (Implies gold drop), random drop (using mod(x, 5))
outcomeLoot = ["You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You find something shiny!" ... 
               "You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You find something shiny!" ...
              "You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You found gold loaves!", "You find something shiny!"];
%START SCREEN
fprintf("Welcome to 'The Elder Rolls V: Ryerim'\n\n");
input("Press any key to start!\n");

%OVERALL GAME LOOP
playAgain = 1;
while playAgain == 1
    clc
    userHealth = 100;
    goldLoaves = 5;
    fprintf("Before you begin, you MUST turn on Caps Lock!\n\n");
    input("Press any key once this is done!");
    clc
    fprintf("Would you like to skip the intro?\n\n");
    fprintf("[1] Don't Skip Intro\n[2] Skip Intro\n");
    introSkip = input("");
    %SKIP INTRO
    if introSkip == 2
        clc
    %INTRO    
    elseif introSkip == 1
        clc
        fprintf("You wrench your eyes open. The moon far above, on your sides a veil of darkness.\nYour head hurts,  as you lie on the grass.\nYou're staring into the darkness that lies beyond the flickering light of a fire.\nYou remember nothing but smell cooked bread faintly in the air.\n\n");
        input("Press any key to continue...");
        clc
        fprintf("You roll slowly and try to sit up. It hurts.\nYou crawl upright.\nOnly the soft grass offers any comfort as your body aches.\nSlowly rising faint memories begin to come back.\nYou had been attacked, but where was the rest of your party?\n\n");
        input("Press any key to continue...");
        clc
        fprintf("You can't remember anything before that.\nGone. You clutch at your memory, but there's nothing but empty air.\n\n");
        input("Press any key to continue...");
        clc
        fprintf("A puddle shimmers in the moonlight.\nYou stumble over cupping the water in your hand, catching a vision of your reflection.\nYou see the burn marks and the your memory rushes back to you...\n\n");
        input("Press any key to continue...");
        clc
        fprintf("The dough dragon...\n\n");
        input("Press any key to continue...");
        clc
        fprintf("You hear a roar in the distance!\nYou have to leave before it returns to finish you off!\n\nThe trees open in four different paths. You must leave, now...\n\n");
        input("Press any key to continue...");
        clc
    end
    playAgain = 0;
    for i = 1 : 1 : 48
    salesIndexSold = 0;
    endingNumber = 0;
    %Displays final turn
    if i == 47
        fprintf("(FINAL TURN)\n\n");
    else
        fprintf("(Turn #%d)\n\n", i);
    end
    %Directional Prompting
    fprintf("Where would you like to travel next?\n\n");
    userDirection = string (input("[N] North\n[S] South\n[E] East\n[W] West\n", "s"));

    %Makes sure the user doesn't travel back where they came from
        while (i > 1) && (userDirection == dontTravelBack)
            clc
            fprintf("You can't travel back where you came from! Pick another direction!\n\n");
            userDirection = string (input("[N] North\n[S] South\n[E] East\n[W] West\n", "s"));
        end
        %If-elseif branches to determine directions
%If user picks North
        if userDirection == "N"
            if mod(i, 5) == 0 %NEW TOWN
                clc
                fprintf("You've entered a new town!\n");
                fprintf("What would you like to do?\n\n");
                fprintf("[1] Shop\n[2] Rest\n[3] Continue your journey\n");
                townChoice = input("");
                %User chooses to shop
                if townChoice == 1
                    [goldLoaves, itemDrop, salesIndexSold, userInventory] = Shop(salesContents, weaponList, goldLoaves, weaponPrices, fieldItems, fieldItemPrices, userInventory);
                %User chooses to rest
                elseif townChoice == 2
                    [userHealth, itemDrop] = Rest();
                %User chooses to continue
                elseif townChoice == 3
                    itemDrop = 0;
                end
            %Boss battle option, every stage 12
            elseif mod(i, 12) == 0
                clc
                fprintf("You come across a strange cave. There are bread crumbs all over...\n");
                fprintf("Would you like to enter the cave and fight the boss?\n\n");
                fprintf("[1] Enter Cave\n[2] Continue Journey...\n");
                fightBoss = input("");
                if fightBoss == 1
                    [endingNumber, userHealth, itemDrop] = BossBattle(userHealth, userCurrentDamage);
                    %If you beat the boss
                    if endingNumber == 2
                        break
                    end
                    if userHealth <= 0
                        clc
                        fprintf("You have perished. Better luck next time traveller.\n");
                        break
                    end
                elseif fightBoss == 2
                    itemDrop = 0;
                end
            %Normal run    
            else
                clc
                fprintf("The journey continues North...\n");
                %Display health and gold
                %"Randomizes stage, outputs components and types
                [stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3] = StageRandomizer(categoryMatrix);
                fprintf("Health: %d\n", userHealth);
                fprintf("Gold Loaves: %d\n\n", goldLoaves);
                %Prompts user to choose interaction
                interactionChoice = PromptInteraction(stageComponent1, stageComponent2, stageComponent3,  categoryType1, categoryType2, categoryType3);
                %if-elseif... based on category type, chooses outcome based on respectiveOutcomeArray
                %Choice 1
                if interactionChoice == 1
                    %Initiate Battle
                    if categoryType1 == 4 
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent1, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function    
                    else
                        itemDrop = OutcomeFunction(categoryType1, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 2    
                elseif interactionChoice == 2
                    %Initiate Battle
                    if categoryType2 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent2, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function       
                    else
                        itemDrop = OutcomeFunction(categoryType2, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 3    
                elseif interactionChoice == 3
                    %Initiate Battle
                    if categoryType3 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent3, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function   
                    else
                        itemDrop = OutcomeFunction(categoryType3, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Inventory    
                elseif interactionChoice == 4
                    [userInventory, userHealth, itemDrop] = CheckInventory(userInventory, userHealth, goldLoaves, weaponList);
                %Quits game    
                elseif interactionChoice == 5
                    endingNumber = 3;
                    break 
                end
            end
%If user picks South
        elseif userDirection == "S"
            if mod(i, 5) == 0 %NEW TOWN
                clc
                fprintf("You've entered a new town!\n");
                fprintf("What would you like to do?\n\n");
                fprintf("[1] Shop\n[2] Rest\n[3] Continue your journey\n");
                townChoice = input("");
                %User chooses to shop
                if townChoice == 1
                    [goldLoaves, itemDrop, salesIndexSold, userInventory] = Shop(salesContents, weaponList, goldLoaves, weaponPrices, fieldItems, fieldItemPrices, userInventory);
                %User chooses to rest
                elseif townChoice == 2
                    [userHealth, itemDrop] = Rest();
                %User chooses to continue
                elseif townChoice == 3
                    itemDrop = 0;
                end
            %Boss battle option, every stage 12
            elseif mod(i, 12) == 0
                clc
                fprintf("You come across a strange cave. There are bread crumbs all over...\n");
                fprintf("Would you like to enter the cave and fight the boss?\n\n");
                fprintf("[1] Enter Cave\n[2] Continue Journey...\n");
                fightBoss = input("");
                if fightBoss == 1
                    [endingNumber, userHealth, itemDrop] = BossBattle(userHealth, userCurrentDamage);
                    %If you beat the boss
                    if endingNumber == 2
                        break
                    end
                    if userHealth <= 0
                        clc
                        fprintf("You have perished. Better luck next time traveller.\n");
                        break
                    end
                elseif fightBoss == 2
                    itemDrop = 0;
                end
            %Normal run
            else
                clc
                fprintf("The journey continues South...\n");
                %Display health and gold
                %"Randomizes stage, outputs components and types
                [stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3] = StageRandomizer(categoryMatrix);
                fprintf("Health: %d\n", userHealth);
                fprintf("Gold Loaves: %d\n\n", goldLoaves);
                %Prompts user to choose interaction
                interactionChoice = PromptInteraction(stageComponent1, stageComponent2, stageComponent3,  categoryType1, categoryType2, categoryType3);
                %if-elseif... based on category type, chooses outcome based on respectiveOutcomeArray
                %Choice 1
                if interactionChoice == 1
                    %Initiate Battle
                    if categoryType1 == 4 
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent1, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function    
                    else
                        itemDrop = OutcomeFunction(categoryType1, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 2    
                elseif interactionChoice == 2
                    %Initiate Battle
                    if categoryType2 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent2, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function       
                    else
                        itemDrop = OutcomeFunction(categoryType2, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 3    
                elseif interactionChoice == 3
                    %Initiate Battle
                    if categoryType3 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent3, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function   
                    else
                        itemDrop = OutcomeFunction(categoryType3, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Inventory    
                elseif interactionChoice == 4
                    [userInventory, userHealth, itemDrop] = CheckInventory(userInventory, userHealth, goldLoaves, weaponList);
                %Quits game    
                elseif interactionChoice == 5
                    endingNumber = 3;
                    break 
                end
            end
%If user picks East
        elseif userDirection == "E"
            if mod(i, 5) == 0 %NEW TOWN
                clc
                fprintf("You've entered a new town!\n");
                fprintf("What would you like to do?\n\n");
                fprintf("[1] Shop\n[2] Rest\n[3] Continue your journey\n");
                townChoice = input("");
                %User chooses to shop
                if townChoice == 1
                    [goldLoaves, itemDrop, salesIndexSold, userInventory] = Shop(salesContents, weaponList, goldLoaves, weaponPrices, fieldItems, fieldItemPrices, userInventory);
                %User chooses to rest
                elseif townChoice == 2
                    [userHealth, itemDrop] = Rest();
                %User chooses to continue
                elseif townChoice == 3
                    itemDrop = 0;
                end
            %Boss battle option, every stage 12
            elseif mod(i, 12) == 0
                clc
                fprintf("You come across a strange cave. There are bread crumbs all over...\n");
                fprintf("Would you like to enter the cave and fight the boss?\n\n");
                fprintf("[1] Enter Cave\n[2] Continue Journey...\n");
                fightBoss = input("");
                if fightBoss == 1
                    [endingNumber, userHealth, itemDrop] = BossBattle(userHealth, userCurrentDamage);
                    %If you beat the boss
                    if endingNumber == 2
                        break
                    end
                    if userHealth <= 0
                        clc
                        fprintf("You have perished. Better luck next time traveller.\n");
                        break
                    end
                elseif fightBoss == 2
                    itemDrop = 0;
                end
            %Normal run    
            else
                clc
                fprintf("The journey continues East...\n");
                %Display health and gold
                %"Randomizes stage, outputs components and types
                [stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3] = StageRandomizer(categoryMatrix);
                fprintf("Health: %d\n", userHealth);
                fprintf("Gold Loaves: %d\n\n", goldLoaves);
                %Prompts user to choose interaction
                interactionChoice = PromptInteraction(stageComponent1, stageComponent2, stageComponent3,  categoryType1, categoryType2, categoryType3);
                %if-elseif... based on category type, chooses outcome based on respectiveOutcomeArray
                %Choice 1
                if interactionChoice == 1
                    %Initiate Battle
                    if categoryType1 == 4 
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent1, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function    
                    else
                        itemDrop = OutcomeFunction(categoryType1, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 2    
                elseif interactionChoice == 2
                    %Initiate Battle
                    if categoryType2 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent2, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function       
                    else
                        itemDrop = OutcomeFunction(categoryType2, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 3    
                elseif interactionChoice == 3
                    %Initiate Battle
                    if categoryType3 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent3, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function   
                    else
                        itemDrop = OutcomeFunction(categoryType3, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Inventory    
                elseif interactionChoice == 4
                    [userInventory, userHealth, itemDrop] = CheckInventory(userInventory, userHealth, goldLoaves, weaponList);
                %Quits game    
                elseif interactionChoice == 5
                    endingNumber = 3;
                    break 
                end
            end
%If user picks West
        elseif userDirection == "W"
            if mod(i, 5) == 0 %NEW TOWN
                clc
                fprintf("You've entered a new town!\n");
                fprintf("What would you like to do?\n\n");
                fprintf("[1] Shop\n[2] Rest\n[3] Continue your journey\n");
                townChoice = input("");
                %User chooses to shop
                if townChoice == 1
                    [goldLoaves, itemDrop, salesIndexSold, userInventory] = Shop(salesContents, weaponList, goldLoaves, weaponPrices, fieldItems, fieldItemPrices, userInventory);
                %User chooses to rest
                elseif townChoice == 2
                    [userHealth, itemDrop] = Rest();
                %User chooses to continue
                elseif townChoice == 3
                    itemDrop = 0;
                end
            %Boss battle option, every stage 12
            elseif mod(i, 12) == 0
                clc
                fprintf("You come across a strange cave. There are bread crumbs all over...\n");
                fprintf("Would you like to enter the cave and fight the boss?\n\n");
                fprintf("[1] Enter Cave\n[2] Continue Journey...\n");
                fightBoss = input("");
                if fightBoss == 1
                    [endingNumber, userHealth, itemDrop] = BossBattle(userHealth, userCurrentDamage);
                    %If you beat the boss
                    if endingNumber == 2
                        break
                    end
                    if userHealth <= 0
                        clc
                        fprintf("You have perished. Better luck next time traveller.\n");
                        break
                    end
                elseif fightBoss == 2
                    itemDrop = 0;
                end
            %Normal run
            else
                clc
                fprintf("The journey continues West...\n");
                %Display health and gold
                %"Randomizes stage, outputs components and types
                [stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3] = StageRandomizer(categoryMatrix);
                fprintf("Health: %d\n", userHealth);
                fprintf("Gold Loaves: %d\n\n", goldLoaves);
                %Prompts user to choose interaction
                interactionChoice = PromptInteraction(stageComponent1, stageComponent2, stageComponent3,  categoryType1, categoryType2, categoryType3);
                %if-elseif... based on category type, chooses outcome based on respectiveOutcomeArray
                %Choice 1
                if interactionChoice == 1
                    %Initiate Battle
                    if categoryType1 == 4 
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent1, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function    
                    else
                        itemDrop = OutcomeFunction(categoryType1, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 2    
                elseif interactionChoice == 2
                    %Initiate Battle
                    if categoryType2 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent2, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function       
                    else
                        itemDrop = OutcomeFunction(categoryType2, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Choice 3    
                elseif interactionChoice == 3
                    %Initiate Battle
                    if categoryType3 == 4
                        [userHealth, itemDrop, endingNumber] = Battle(userHealth, stageComponent3, userCurrentDamage);
                        %User dies, end game...
                        if userHealth <= 0
                            clc
                            fprintf("You have perished. Better luck next time traveller.\n");
                            break
                        end
                    %Initiate outcome function   
                    else
                        itemDrop = OutcomeFunction(categoryType3, outcomeNpc, outcomeMisc, outcomeLoot);
                        input("\nPress any key to continue...\n", "s");
                    end
                %Inventory    
                elseif interactionChoice == 4
                    [userInventory, userHealth, itemDrop] = CheckInventory(userInventory, userHealth, goldLoaves, weaponList);
                %Quits game    
                elseif interactionChoice == 5
                    endingNumber = 3;
                    break 
                end
            end
        end
    %Calls function to set directional logic
        prevUserDirection = userDirection;
        dontTravelBack = DirectionalLogic(prevUserDirection);
        [dropType, dropIndex] = ItemDrop(itemDrop, weaponList, fieldItems, salesIndexSold);
        [userCurrentDamage, goldLoaves, userInventory] = UpdateInventory(dropType, dropIndex, userInventory, userBaseDamage, userCurrentDamage, weaponList, fieldItems, goldLoaves, weaponDamage, salesContents);
        clc
    end
    %Respective ending
    %GAME ENDING TYPE
    if endingNumber == 1
        %Death dialogue...
    elseif endingNumber == 2
        clc
        fprintf("You have defeated the dough dragon and avenged your family!\n");
    elseif endingNumber == 3
        clc
        fprintf("You quit the game!\n");
    end
    fprintf("\nThank you for playing!\n");
    fprintf("Would you like to play again?\n\n");
    fprintf("[1] Restart\n[2] Quit\n");
    playAgain = input("");
    clc
    if playAgain == 2
        fprintf("Thanks to:\n\nTim Lewis\nTyler Estrada\nEvan Hayslip\nAll of the TAs\nDr. Thomas\n\n");
        fprintf("Goodbye!");
    end
end

%                               !FUNCTIONS ONLY BELOW!

%Function to set direction NOT to travel (prevents redundant travel logic)
function dontTravelBack = DirectionalLogic(prevUserDirection)
    if prevUserDirection == "N"
        dontTravelBack = "S";
    elseif prevUserDirection == "S"
        dontTravelBack = "N";
    elseif prevUserDirection == "E"
        dontTravelBack = "W";
    elseif prevUserDirection == "W"
        dontTravelBack = "E";
    end
end

%Function outputs surroundings of each stage
function [stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3] = StageRandomizer(categoryMatrix)
    %Logs category type of each newly set stage component
    categoryType1 = randi(4);
    categoryType2 = randi(4);
    categoryType3 = randi(4);
    stageComponent1 = categoryMatrix(randi(4), categoryType1);
    stageComponent2 = categoryMatrix(randi(4), categoryType2);
    stageComponent3 = categoryMatrix(randi(4), categoryType3);
    %Randomizes text to prevent mundanity
    textRandomizer = randi(3);
    if textRandomizer == 1
        fprintf("You come across ");
    elseif textRandomizer == 2
        fprintf("Your surroundings include ");
    else
        fprintf("Nearby there is ");
    end
    %Branches to output different variations depending on plurality
    if stageComponent1 == stageComponent2
        fprintf("a %s, a %s, and another %s!\n\n", stageComponent3, stageComponent2, stageComponent1);
    elseif stageComponent2 == stageComponent3
        fprintf("a %s, a %s, and another %s!\n\n", stageComponent1, stageComponent2, stageComponent3);
    elseif stageComponent1 == stageComponent3
        fprintf("a %s, a %s, and another %s!\n\n", stageComponent2, stageComponent3, stageComponent1);
    else
        fprintf("a %s, a %s, and a %s.\n\n", stageComponent1, stageComponent2, stageComponent3);
    end
end

%Function outputs user's choice
function interactionChoice = PromptInteraction(stageComponent1, stageComponent2, stageComponent3, categoryType1, categoryType2, categoryType3)
    fprintf("What would you like to do?\n\n");
    %Interaction 1
    fprintf("[1] ");
    if categoryType1 == 1
        fprintf("Approach the %s\n", stageComponent1);
    elseif categoryType1 == 2
        fprintf("Investigate the %s\n", stageComponent1);
    elseif categoryType1 == 3
        fprintf("Loot the %s\n", stageComponent1);
    elseif categoryType1 == 4
        fprintf("Battle the %s\n", stageComponent1);
    end
    %Interaction 2
    fprintf("[2] ");
    if categoryType2 == 1
        fprintf("Approach the %s\n", stageComponent2);
    elseif categoryType2 == 2
        fprintf("Investigate the %s\n", stageComponent2);
    elseif categoryType2 == 3
        fprintf("Loot the %s\n", stageComponent2);
    elseif categoryType2 == 4
        fprintf("Battle the %s\n", stageComponent2);
    end
    %Interaction 3
    fprintf("[3] ");
    if categoryType3 == 1
        fprintf("Approach the %s\n", stageComponent3);
    elseif categoryType3 == 2
        fprintf("Investigate the %s\n", stageComponent3);
    elseif categoryType3 == 3
        fprintf("Loot the %s\n", stageComponent3);
    elseif categoryType3 == 4
        fprintf("Battle the %s\n", stageComponent3);
    end
    %Choices 4 and 5
    fprintf("[4] Inventory\n");
    fprintf("[5] Quit Game\n");
    interactionChoice = input("");
end
%Function outputs the respective outcome of the users choice
function itemDrop = OutcomeFunction(categoryType, outcomeNpc, outcomeMisc, outcomeLoot) %When done, double check if weaponNames needs to remain
%ITEM DROP: 0 = no drop, 1 = items/weapons, 2 = item only, 3 = gold only
    %NPC
    clc
    if categoryType == 1 %If the component is an npc
        currentIndex = randi(length(outcomeNpc));
        if mod(currentIndex, 5) == 0 %Every fifth item is an item drop
            fprintf("%s\n", outcomeNpc(currentIndex));
            itemDrop = 1; %items/weapons
        else
            fprintf("%s\n", outcomeNpc(currentIndex));
            itemDrop = 0; %no drop
        end
    %Misc.
    elseif categoryType == 2 %If the component is a misc. type
        currentIndex = randi(length(outcomeMisc));
        if mod(currentIndex, 5) == 0 %Every fifth item is an item drop
            fprintf("%s\n", outcomeMisc(currentIndex));
            itemDrop = 2; %item only
        else
            fprintf("%s\n", outcomeMisc(currentIndex));
            itemDrop = 3; %gold only
        end
    %Loot
    else %If the component is loot
        currentIndex = randi(length(outcomeLoot));
        if mod(currentIndex, 5) == 0 %Every fifth item is a drop
            fprintf("%s\n", outcomeLoot(currentIndex));
            itemDrop = 2; %
        else
            fprintf("%s\n", outcomeLoot(currentIndex));
            itemDrop = 3;
        end
    end
end
%Battle function
function [newHealth, itemDrop, endingNumber] = Battle(health, currentEnemy, userDamage)
    clc
    newHealth = health;
    itemDrop = 0;
    endingNumber = 0;
    %Toaster Damage: 20-40 Health: 50
    toastDamage = 20 + randi(20);
    toastHealth = 50;
    %Pack of Cutting Boards Damage: 10-25 Health: 40
    cuttingDamage = 10 + randi(15);
    cuttingHealth = 40;
    %Bread Knife Damage: 10 - 15 Health: 30
    breadDamage = 10 + randi(5);
    breadHealth = 30;
    %Butter Knife Damage: 0-10 Health: 20
    butterDamage = randi(10);
    butterHealth = 20;

    j=1;
    fprintf("You are battling %s!\n\n", currentEnemy);
    while j<2
    fprintf("What would you like to do?\n");
        if currentEnemy == 'Toaster'
            userOption = string (input("[1] Attack\n[2] Flee\n", "s"));
            if userOption == '1'
                clc
                randomCrit = randi(7);
                if randomCrit == 4
                    toastHealth = toastHealth - userDamage;
                    fprintf("You did %d damage!\n\n", userDamage);
                    input("Press any key to continue...\n");
                else
                    toastHealth = toastHealth - (userDamage + 10);
                    fprintf("You did %d damage! Critical Hit!\n\n", userDamage + 10);
                    input("Press any key to continue...");
                end
                if toastHealth == 0
                    break
                end
                clc
                fprintf("The Toaster's health is %.1f\n", toastHealth)
                if toastHealth <= 0
                    fprintf("You have defeated the Toaster!\n");
                    itemDrop = 3;
                    j = 2;
                end
                fprintf("The Toaster fights back!\n");
                newHealth = newHealth - toastDamage;
                fprintf("Your health is %.1f\n", newHealth);
                if newHealth <= 0
                    fprintf("You have been defeated by the Toaster!\n");
                    endingNumber = 1;
                    j = 2;
                end  
            elseif userOption == '2'
                fprintf("You have run away from the Toaster!\n");
                j = 2;
            end
        end
        if currentEnemy == 'Pack of Cutting Boards'
            userOption = string (input("[1] Attack\n[2] Flee\n", "s"));
            if userOption == '1'
                clc
                randomCrit = randi(7);
                if randomCrit == 4
                    cuttingHealth = cuttingHealth - userDamage;
                    fprintf("You did %d damage!\n\n", userDamage);
                    input("Press any key to continue...\n");
                else
                    cuttingHealth = cuttingHealth - (userDamage + 10);
                    fprintf("You did %d damage! Critical Hit!\n\n", userDamage + 10);
                    input("Press any key to continue...");
                end
                if cuttingHealth == 0
                    break
                end
                clc
                fprintf("The Pack of Cutting Board's health is %.1f\n", cuttingHealth)
                 if cuttingHealth <= 0
                    fprintf("You have defeated the Cutting Boards!\n");
                    itemDrop = 3;
                    j = 2;
                 end
                 fprintf("The Cutting Boards fight back!\n")
                newHealth = newHealth - cuttingDamage;
                fprintf("Your health is %.1f\n",newHealth);
                if newHealth <= 0
                    fprintf("You have been defeated by the Cutting Boards!\n");
                    endingNumber = 1;
                    j = 2;
                end
               
            elseif userOption == '2'
                fprintf("You have run away from the Cutting Boards!\n");
                j = 2;
            end
        end
        if currentEnemy == 'Bread Knife'
            userOption = string (input("[1] Attack\n[2] Flee\n", "s"));
            if userOption == '1'
                clc
                randomCrit = randi(7);
                if randomCrit == 4
                    breadHealth = breadHealth - userDamage;
                    fprintf("You did %d damage!\n\n", userDamage);
                    input("Press any key to continue...\n");
                else
                    breadHealth = breadHealth - (userDamage + 10);
                    fprintf("You did %d damage! Critical Hit!\n\n", userDamage + 10);
                    input("Press any key to continue...");
                end
                if breadHealth == 0
                    break
                end
                clc
                fprintf("The Bread Knife's health is %.1f\n", breadHealth)
                if breadHealth <= 0
                    fprintf("You have defeated the Bread Knife!\n");
                    itemDrop = 3;
                    j = 2;
                end
                fprintf("The Bread Knife fights back!\n")
                newHealth = newHealth - breadDamage;
                fprintf("Your health is %.1f\n",newHealth);
                if newHealth <= 0
                    fprintf("You have been defeated by the Bread Knife!\n");
                    itemDrop = 0;
                    endingNumber = 1;
                    j = 2;
                end
            elseif userOption == '2'
                fprintf("You have run away from the Bread Knife!\n");
                j = 2;
            end
        end
        if currentEnemy == 'Butter Knife'
            userOption = string (input("[1] Attack\n[2] Flee\n", "s"));
            if userOption == '1'
                clc
                randomCrit = randi(7);
                if randomCrit == 4
                    butterHealth = butterHealth - userDamage;
                    fprintf("You did %d damage!\n\n", userDamage);
                    input("Press any key to continue...\n");
                else
                    butterHealth = butterHealth - (userDamage + 10);
                    fprintf("You did %d damage! Critical Hit!\n\n", userDamage + 10);
                    input("Press any key to continue...");
                end
                if butterHealth == 0
                    break
                end
                clc
                fprintf("The Butter Knife's health is %.1f\n", butterHealth)
                 if butterHealth <= 0
                    fprintf("You have defeated the Butter Knife!\n");
                    itemDrop = 3;
                    j = 2;
                 end
                 fprintf("The Butter Knife fights back!\n")
                newHealth = newHealth - butterDamage;
                fprintf("Your health is %.1f\n", newHealth);
                if newHealth <= 0
                    fprintf("You have been defeated by the Butter Knife!\n");
                    endingNumber = 1;
                    j = 2;
                end  
            elseif userOption == '2'
                fprintf("You have run away from the Butter Knife!\n");
                j = 2;
            end
        end
    end
    clc
    if newHealth > 0
        if userOption == '2'
            fprintf("You managed to escape from the %s.\n\n", currentEnemy);
        else
        fprintf("You defeated the %s!\n\n", currentEnemy);
        end
    else
        fprintf("The %s deafeated you!\n\n", currentEnemy);
        endingNumber = 1;
    end
    input("Press any key to continue...\n");
end
%Determines item drop type and index
function [dropType, dropIndex] = ItemDrop(itemDrop, weaponList, fieldItems, salesIndexSold)
    %DROPTYPE: 0 = n/a, 1 = weapon, 2 = item, 3 = gold
    %ITEM DROP: 0 = no drop, 1 = items/weapons, 2 = item only, 3 = gold only
    clc
    %Branches depending on item drop type
    %NOTHING HAPPENS
    if itemDrop == 0
        %Returns nothing
        dropType = 0;
        dropIndex = 0;
        fprintf("You continue on.\n\n");
    %NPC ONLY
    elseif itemDrop == 1
        npcRandomize = randi(10);
        %Randomizes whether npc drops item or weapon
        if (mod(npcRandomize, 5) == 0) || (salesIndexSold > 0)
            if salesIndexSold > 0
                dropType = 1;
                dropIndex = salesIndexSold;
                fprintf("You recieved a %s!\n\n", weaponList(dropIndex, 1));
            else
                %Returns random weapon
                dropType = 1;
                dropIndex = randi(length(weaponList));
                fprintf("You recieved a %s!\n\n", weaponList(dropIndex, 1));
            end
        else
            %Returns random item
            dropType = 2;
            dropIndex = randi(length(fieldItems));
            fprintf("You recieved a %s!\n\n", fieldItems(dropIndex));
        end
    %ITEM ONLY
    elseif itemDrop == 2
        dropType = 2;
        dropIndex = randi(length(fieldItems));
        fprintf("You obtained a %s!\n\n", fieldItems(dropIndex));
    %GOLD ONLY
    elseif itemDrop == 3
        dropType = 3;
        dropIndex = 15 + randi(65);
        fprintf("You obtained %d gold!\n\n", dropIndex);
    %POTION ONLY
    else
        dropType = 4;
        if itemDrop == 4
            fprintf("You obtained a potion!\n\n");
            dropIndex = 1;
        elseif itemDrop == 5
            fprintf("You obtained a big potion!\n\n");
            dropIndex = 2;
        end
    end
    input("Press any key to continue...\n", "s");
end
%Updates Inventory each round
function [userCurrentDamage, goldLoaves, userInventory] = UpdateInventory(dropType, dropIndex, userInventory, userBaseDamage, userCurrentDamage, weaponList, fieldItems, goldLoaves, weaponDamage, salesContents)
    clc
    %If na
    if dropType == 0
    %If weapon
    elseif dropType == 1
        fprintf("Would you like to switch out your current weapon for a %s?\n\n", weaponList(dropIndex, 1));
        userInput = input("[1] Yes\n[2] No\n");
        %Switches weapon in inventory slot 1
        if userInput == 1
            userInventory(1) = weaponList(dropIndex, 1);
            userCurrentDamage = userBaseDamage + weaponDamage(dropIndex);
        else
            %Continue
        end
    %If item
    elseif dropType == 2
        fprintf("Would you like to switch out an item in your inventory for a %s?\n\n", fieldItems(dropIndex));
        userInput = input("[1] Yes\n[2] No\n");
        if userInput == 1
            clc
            fprintf("Which item would you like to replace?\n\n");
            fprintf("[1] %s\n[2] %s\n[3] Cancel\n", userInventory(2), userInventory(3));
            slotChoice = input("");
            if slotChoice == 1
                userInventory(2) = fieldItems(dropIndex);
            elseif slotChoice == 2
                userInventory(3) = fieldItems(dropIndex);
            else
                %Cancels choice
            end
        else
            %Continue
        end
    %If gold
    elseif dropType == 3
        goldLoaves = goldLoaves + dropIndex;
    %If potion
    elseif dropType == 4
        clc
        fprintf("Which item would you like to replace?\n\n");
        fprintf("[1] %s\n[2] %s\n[3] Cancel\n", userInventory(2), userInventory(3));
        slotChoice = input("");
        if slotChoice == 1
            userInventory(2) = salesContents(dropIndex);
        elseif slotChoice == 2
            userInventory(3) = salesContents(dropIndex);
        end
    end
end
%Shop function
function [goldLoaves, itemDrop, salesIndexSold, userInventory] = Shop(salesContents, weaponList, goldLoaves, weaponPrices, fieldItems, fieldItemPrices, userInventory)
    fprintf("You have chosen to stop by the nearest shop!\n");
    %Sets sales choices and prices
    dropIndex = randi(length(weaponList));
    potionDropIndex = randi(2);
    potionPrice = 100;
    bigPotionPrice = 350;
    inventoryItem1 = userInventory(1);
    inventoryItem2 = userInventory(2);
    inventoryItem3 = userInventory(3);
    salesIndexSold = 0;
    %Shop menu
    k = 1;
    while k<2
        clc
        salesChoice1 = weaponList(dropIndex, 1); %Random weapon
        salesChoice2 = salesContents(potionDropIndex); %Small or Big Potion
        %Sets weapon price 
        if salesChoice1 == "Weak Brioche Baton"
            weaponPrice = weaponPrices(1);
            salesIndex = 1;
        elseif salesChoice1 == "Medium Burnt Baguette Bat"
            weaponPrice = weaponPrices(2);
            salesIndex = 2;
        elseif salesChoice1 == "Strong Whole Wheat Whip"
            weaponPrice = weaponPrices(3);
            salesIndex = 3;
        elseif salesChoice1 == "Legendary Gold Plated Costa Del Sol Sword"
            weaponPrice = weaponPrices(11);
            salesIndex = 11;
        end
        fprintf("What would you like to do?\n\n");
        userShop = input("[1] Buy\n[2] Sell\n[3] Exit\n");
        %Buy Option
        if userShop == 1
            clc
            fprintf("Here's what we have today!\n\n");
            if potionDropIndex == 1
                fprintf("[1] %s (%s Gold Loaves)\n[2] %s (%d Gold Loaves)\n[3] Return\n", salesChoice1, weaponList(dropIndex, 3), salesChoice2, potionPrice);
            else
                fprintf("[1] %s (%s Gold Loaves)\n[2] %s (%d Gold Loaves)\n[3] Return\n", salesChoice1, weaponList(dropIndex, 3), salesChoice2, bigPotionPrice);
            end
            userBuy = input("");
            %User purchases weapon
            if userBuy == 1
                %If user has enough gold    
                if goldLoaves >= weaponPrices(dropIndex)
                    goldLoaves = goldLoaves - weaponPrice;
                    fprintf('You have purchased a %s!\n', salesChoice1);
                    itemDrop = 1;
                    salesIndexSold = salesIndex;
                    k = 2;
                %If user doesn't have enough gold
                else
                    clc
                    fprintf('You do not have enough gold loaves for that!\n\n');
                    input("Press any key to continue...");
                end
            %User purchses potion
            elseif userBuy == 2
                %Inventory Function with the potion choice
                %Potion sold is little
                if (potionDropIndex == 1) && (goldLoaves >= potionPrice)

                    goldLoaves = goldLoaves - potionPrice;
                    fprintf('You have purchased a %s!\n', salesContents(1));
                    itemDrop = 4;
                    k = 2;
                %Potion sold is big
                elseif (potionDropIndex == 2) && (goldLoaves >= bigPotionPrice)
                    goldLoaves = goldLoaves - bigPotionPrice;
                    fprintf('You have purchased a %s!\n', salesContents(1));
                    itemDrop = 5;
                    k = 2;
                %If user doesn't have enough gold
                else
                    clc
                    fprintf('You do not have enough gold loaves for that!\n\n');
                    input("Press any key to continue...");
                end
            end
        %Sell Option
        elseif userShop == 2
            clc
            fprintf("Which would you like to sell?\n\n");
            fprintf("[1] %s\n[2] %s\n[3] %s\n[4] Return\n", userInventory(1), userInventory(2), userInventory(3));
            sellChoice = input("");
            if sellChoice == 1
                if userInventory(1) == "Weak Brioche Baton"
                    clc
                    price = weaponPrices(1);
                    fprintf("You recieved %d Gold Loaves!\n\n", weaponPrices(1));
                    input("Press any key to continue...");
                    goldLoaves = goldLoaves + price;
                    userInventory(1) = "Empty Weapon Slot";
                elseif userInventory(1) == "Medium Burnt Baguette Bat"
                    clc
                    price = weaponPrices(2);
                    fprintf("You recieved %d Gold Loaves!\n\n", weaponPrices(2));   
                    input("Press any key to continue...");
                    goldLoaves = goldLoaves + price;
                    userInventory(1) = "Empty Weapon Slot";
                elseif userInventory(1) == "Strong Whole Wheat Whip"
                    clc
                    price = weaponPrices(3);
                    fprintf("You recieved %d Gold Loaves!\n\n", weaponPrices(3));
                    input("Press any key to continue...");
                    goldLoaves = goldLoaves + price;
                    userInventory(1) = "Empty Weapon Slot";
                elseif userInventory(1) == "Legendary Gold Plated Costa Del Sol Sword"
                    clc
                    price = weaponPrices(11);
                    fprintf("You recieved %d Gold Loaves!\n\n", weaponPrices(11));
                    input("Press any key to continue...");
                    goldLoaves = goldLoaves + price;
                    userInventory(1) = "Empty Weapon Slot";
                 elseif userInventory(1) == "Empty Weapon Slot"
                    clc
                    fprintf("This slot is empty!\n");
                    input("Press any key to continue...");
                end
            elseif sellChoice == 2
                if userInventory(2) == "Potion"
                    clc
                    price = 30;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Big Potion"
                    clc
                    price = 100;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Wheat Amulet"
                    clc
                    price = 40;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "China Bread Bowl"
                    clc
                    price = 50;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Golden Bread Clip"
                    clc
                    price = 60;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Silk Oven Mitts"
                    clc
                    price = 50;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Golden Brown Bread Crust"
                    clc
                    price = 35;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Extra Virgin Olive Oil Bottle"
                    clc
                    price = 100;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Rare Oven Parts"
                    clc
                    price = 70;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Iron Tray"
                    clc
                    price = 25;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Ball of Tin Foil"
                    clc
                    price = 20;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(2) = "Empty Item Slot";
                elseif userInventory(2) == "Empty Item Slot"
                    clc
                    fprintf("This slot is empty!\n");
                    input("Press any key to continue...");
                end
            elseif sellChoice == 3
                if userInventory(3) == "Potion"
                    clc
                    price = 30;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Big Potion"
                    clc
                    price = 100;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Wheat Amulet"
                    clc
                    price = 40;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "China Bread Bowl"
                    clc
                    price = 50;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Golden Bread Clip"
                    clc
                    price = 60;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Silk Oven Mitts"
                    clc
                    price = 50;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Golden Brown Bread Crust"
                    clc
                    price = 35;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Extra Virgin Olive Oil Bottle"
                    clc
                    price = 100;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Rare Oven Parts"
                    clc
                    price = 70;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Iron Tray"
                    clc
                    price = 25;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Ball of Tin Foil"
                    clc
                    price = 20;
                    fprintf("You recieved %d Gold Loaves!\n\n", price);
                    goldLoaves = goldLoaves + price;
                    input("Press any key to continue...");
                    userInventory(3) = "Empty Item Slot";
                elseif userInventory(3) == "Empty Item Slot"
                    clc
                    fprintf("This slot is empty!\n");
                    input("Press any key to continue...");
                end
            elseif sellChoice == 4
                %Continues to menu
            end
            itemDrop = 0;
        %Quit Option
        elseif userShop == 3
            itemDrop = 0;
            k = 2;
        end
    end
end
%Rest option
function [userHealth, itemDrop] = Rest()
    clc
    fprintf("You are led in to a tavern room.\nYour eyes shut the instant you lay down...\n\n");
    input("You wake up feeling rested! Press any key to continue...");
    userHealth = 100;
    itemDrop = 0;
end
%User checks inventory
function [userInventory, userHealth, itemDrop] = CheckInventory(userInventory, userHealth, goldLoaves, weaponList)
    menuChoice = 0;
    while menuChoice ~= 4
        clc
        fprintf("Inventory Menu \n");
        fprintf("Health: %d\n", userHealth);
        fprintf("Gold Loaves: %d\n\n", goldLoaves);
        fprintf("Choose what you'd like to interact with!\n\n");
        fprintf("[1] %s\n[2] %s\n[3] %s\n[4] Quit Menu\n", userInventory(1), userInventory(2), userInventory(3));
        menuChoice = input("");
        %If user chooses to interact w weapon
        if menuChoice == 1
            clc
            %If slot is empty
            if userInventory(1) == "Empty Weapon Slot"
                fprintf("This slot is empty!\n\n");
                input("Press any key to return to menu...")
            %Full slot
            else
                fprintf("You wield a %s!\n", userInventory(1));
                fprintf("What would you like to do with your weapon?\n\n");
                fprintf("[1] Inspect\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User inspects w weapon
                if slotChoice == 1
                    clc
                    fprintf("Your weapon is shiny!\n");
                    %Depends on weapon
                    %Weapon is weak
                    if userInventory(1) == "Weak Brioche Baton"
                        fprintf("It does %s damage!\n", weaponList(1, 2));
                        fprintf("Sales price would be %s!", weaponList(1, 3));
                    elseif userInventory(1) == "Medium Burnt Baguette Bat"
                        fprintf("It does %s damage!\n", weaponList(2, 2));
                        fprintf("Sales price would be %s!", weaponList(2, 3));    
                    elseif userInventory(1) == "Strong Whole Wheat Whip"
                        fprintf("It does %s damage!\n", weaponList(3, 2));
                        fprintf("Sales price would be %s!", weaponList(3, 3)); 
                    elseif userInventory(1) == "Legendary Gold Plated Costa Del Sol Sword"
                        fprintf("It does %s damage!\n", weaponList(11, 2));
                        fprintf("Sales price would be %s!", weaponList(11, 3));
                    end
                input("\n\nPress any key to return to menu...");
                %User drops weapon    
                elseif slotChoice == 2
                    clc
                    fprintf("Your weapons slot is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(1) = "Empty Weapon Slot";
                %User returns to menu    
                else
                    %N/A
                end
            end
        %If user chooses to interact w item slot 1    
        elseif menuChoice == 2
            clc
            %Item is little potion
            if userInventory(2) == "Empty Item Slot"
                fprintf("This slot is empty!\n\n");
                input("Press any key to return to menu...")
            elseif userInventory(2) == "Potion"
                fprintf("What would you like to do with your potion?\n\n");
                fprintf("[1] Use\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to use potion
                if slotChoice == 1
                    clc
                    fprintf("Your health has been restored by 20!");
                    userHealth = userHealth + 20;
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User chooses to drop potion    
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 2 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User chooses to return to menu   
                else
                    clc
                end
            %Item is big potion        
            elseif userInventory(2) == "Big Potion"
                clc
                fprintf("What would you like to do with your big potion?\n\n");
                fprintf("[1] Use\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to use potion
                if slotChoice == 1
                    clc
                    fprintf("Your health has been restored by 50!");
                    userHealth = userHealth + 50;
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User chooses to drop potion    
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 2 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User chooses to return to menu   
                else
                    clc
                end
            %Misc. item    
            else
                clc
                fprintf("What would you like to do with your item?\n\n");
                fprintf("[1] Inspect\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to inspect item
                if slotChoice == 1
                    clc
                    fprintf("This looks expensive!\n\n");
                    input("Press any key to return to menu...");
                %User chooses to drop item
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 2 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User returns to menu   
                else
                    clc
                end
            end
        %If user chooses to interact w item slot 2    
        elseif menuChoice == 3
            clc
            %Item is little potion
            if userInventory(3) == "Empty Item Slot"
                fprintf("This slot is empty!\n\n");
                input("Press any key to return to menu...");
            elseif userInventory(3) == "Potion"
                fprintf("What would you like to do with your potion?\n\n");
                fprintf("[1] Use\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to use potion
                if slotChoice == 1
                    clc
                    fprintf("Your health has been restored by 20!");
                    userHealth = userHealth + 20;
                    input("Press any key to return to menu...");
                    userInventory(3) = "Empty Item Slot";
                %User chooses to drop potion    
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 3 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(3) = "Empty Item Slot";
                %User chooses to return to menu   
                else
                    clc
                end
            %Item is big potion        
            elseif userInventory(3) == "Big Potion"
                clc
                fprintf("What would you like to do with your big potion?\n\n");
                fprintf("[1] Use\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to use potion
                if slotChoice == 1
                    clc
                    fprintf("Your health has been restored by 50!");
                    userHealth = userHealth + 50;
                    input("Press any key to return to menu...");
                    userInventory(3) = "Empty Item Slot";
                %User chooses to drop potion    
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 3 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(3) = "Empty Item Slot";
                %User chooses to return to menu   
                else
                    clc
                end
            %Misc. item    
            else
                clc
                fprintf("What would you like to do with your item?\n\n");
                fprintf("[1] Inspect\n[2] Drop\n[3] Return to Menu\n");
                slotChoice = input("");
                %User chooses to inspect item
                if slotChoice == 1
                    clc
                    fprintf("This looks expensive!\n\n");
                    input("Press any key to return to menu...");
                %User chooses to drop item
                elseif slotChoice == 2
                    clc
                    fprintf("Item slot 3 is now empty!\n\n")
                    input("Press any key to return to menu...")
                    userInventory(2) = "Empty Item Slot";
                %User returns to menu   
                else
                    clc
                end
            end
        elseif menuChoice == 4
            clc
            itemDrop = 0;
        end
    end
    itemDrop = 0;
end
%Boss battle
function [endingNumber, userHealth, itemDrop] = BossBattle(userHealth, userDamage)

%Once you defeat it this will become 1 and will end the game and prompt the
%user with congrats in the main function
clc
endingNumber = 0;

doughHealth = 600;
doughDamage = 40;
itemDrop = 0;

j=1;
fprintf("You are battling the Dough Dragon!\n");
    while j<2
        fprintf("What would you like to do?\n\n");    
        userOption = string (input("[1] Attack\n[2] Flee\n", "s"));
        if userOption == '1'
            doughHealth = doughHealth - userDamage;
            clc
            fprintf("The Dough Dragon's health is %.1f\n", doughHealth)
        if doughHealth <= 0
            fprintf("You have defeated the Dough Dragon!\n");
            endingNumber = 2;
            j = 2;
        end
        fprintf("The Dough Dragon fights back!\n")
        doughChance = randi(6);
        if doughChance == 6
            userHealth = userHealth - doughDamage;
        else
            fprintf("The Dough Dragon barely missed you!\n");
        end
        fprintf("Your health is %.1f\n", userHealth);
        if userHealth <= 0
            fprintf("You have been consumed by the Dough Dragon!\n");
            endingNumber = 1;
            j = 2;
        end  
        elseif userOption == '2'
            fprintf("You have run away from the Dough!\n");
            j = 2;
        end
    end
end