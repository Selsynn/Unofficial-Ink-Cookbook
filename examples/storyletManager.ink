//The content that is accessible at the beginning.
LIST basicContent = ContentBasic1, ContentBasic2, ContentRandom3

//Some secret content - content to unlock at some point
LIST secretContent = ContentSecret1, ContentSecret2

//This is the true containers for all the content the players could have. 
//If it is in this variable, it can be accessible. Else it is not accessible.
VAR contentAvailable = ()
//At the beginning, all the basic content is inside. No secret content
~ contentAvailable = LIST_ALL(basicContent)

//There is two approach. RandomContentNode will display a content randomly.
//RandomChoiceNode will display a choice randomly.
//They are working on the same way, but the handling is different
->RandomContentNode

=== RandomContentNode
//First we need to get ONE random entry from the content available to the player
~ temp randomContent = LIST_RANDOM(contentAvailable)

//Big swith to handle this value. If you just want to display a choice, look at the second example RandomChoiceNode
{
- randomContent ? ContentBasic1:
    Content Basic 1
    //This node give access to a new secret. We add it to the list like this:
    ~ contentAvailable += ContentSecret1 
- randomContent == ContentBasic2:
    Content Basic 2
    //This one, however add a new secret, and remove a outdated content element. 
    //Note: it's safe to do, even if the content element is not anymore, or has never been in the list.
    ~ contentAvailable += ContentSecret2
    ~ contentAvailable -= ContentRandom3
- randomContent == ContentRandom3:
    Random Content
- randomContent == ContentSecret1:
    You have a secret content!
- randomContent == ContentSecret2:
    You have the super secret content!
- else:
    //FallBack - we don't want the player to be stuck somewhere. Always have fallback.
    //Here, for this example, we will switch to the RandomChoiceNode
    ~ contentAvailable = LIST_ALL(basicContent)
    ->RandomChoiceNode
}

//We remove the current element from the list, to prevent player to see it more than one time.
~ contentAvailable -= randomContent

//Here we go back to the node to display everything. You could go higher at another node that call the RandomContentNode
->RandomContentNode

=== RandomChoiceNode
~ temp randomContent = LIST_RANDOM(contentAvailable)
//Here instead of a big switch with the condition, we have the condition in front of each of the choice.
*{randomContent == ContentBasic1} Choice Basic1 
    //When the choice is done, we apply effects.
    ~ contentAvailable += ContentSecret1
*{randomContent == ContentBasic2} Choice Basic2
    ~ contentAvailable += ContentSecret2
    ~ contentAvailable -= ContentRandom3
*{randomContent == ContentRandom3} Choice Random 
*{randomContent == ContentSecret1} Choice secret!
*{randomContent == ContentSecret2} Choice super secret!
* ->DONE //Fallback choice -> here we close the story.
- //We gather after any of these choices
//We remove the current element from the list of available content
~ contentAvailable -= randomContent
//And we exit (or loop back to RandomChoiceNode in this case).
->RandomChoiceNode
