package events
{
import flash.events.Event;

public class XMLParsedEvent extends Event
{
    public static const PARSED:String = "parsed";

    public function XMLParsedEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(type, bubbles, cancelable);
    }
}
}
