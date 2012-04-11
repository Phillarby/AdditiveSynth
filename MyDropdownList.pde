/*
IMPORTANT NOTE: All classes in this file were provided as is by a user of the processing forum to add funtionality to the standard dropdown list provided in the ControlP5 Library
                Thanks and acknowledgement go the poster 'Bustup'
                The originating thread can be seen here: http://forum.processing.org/topic/controlp5-dropdown-setvalue#25080000001316265
*/

public class MyDropdownList extends MyListBox {
      
  public MyDropdownList(ControlP5 controlP5, ControlGroup cb, String name, int x, int y, int w, int h) {
    super(controlP5, cb, name, x, y, w, h);
  }
  
  public void setIndex(float theValue) {
    for (int i = 0; i < items.size(); i++) {
      MyListBoxItem l = items.get(i);

      if ((l.getValue() == theValue)) {
        _myValue = l.getValue();
        setLabel(l.getName());
        break;
      }
    }
  }
}
    
public class MyListBox extends ListBox {
      
  private ControlP5 controlP5;
  protected List<MyListBoxItem> items;
  
  public MyListBox(ControlP5 controlP5, ControlGroup cb, String name, int x, int y, int w, int h) {
    super(controlP5, cb, name, x, y, w, h);
    this.controlP5 = controlP5;
    items = new ArrayList<MyListBoxItem>();
  }
  
  @Override
  public MyListBoxItem addItem(String theName, int theValue) {
    MyListBoxItem lbi = new MyListBoxItem(this, theName, theValue);
    items.add(lbi);
    addListButton(1, theName);
    return lbi;
  }
  
  @Override
  public MyListBoxItem item(int theIndex) {
    return ((MyListBoxItem) items.get(theIndex));
  }
  
  @Override
  public MyListBoxItem item(String theItemName) {
    for (int i = items.size() - 1; i >= 0; i--) {
      if ((items.get(i)).getName().equals(theItemName)) {
        return items.get(i);
      }
    }
    return null;
  }
  
  protected void addListButton(int theNum, String name) {
    for (int i = 0; (i < theNum) && (buttons.size() < maxButtons); i++) {
      int index = buttons.size();
      MyButton b = new MyButton(controlP5, (ControllerGroup) this, name, index, 0, index * (_myItemHeight + spacing), _myWidth, _myItemHeight, false);
      b.setMoveable(false);
      add(b);
      controlP5.register(b);
      b.setBroadcast(false);
      b.addListener(this);
      buttons.add(b);
    }
  }
}

public class MyButton extends Button {
      
  public MyButton(ControlP5 theControlP5, ControllerGroup theParent, String theName, float theDefaultValue, int theX, int theY, int theWidth, int theHeight, boolean theBroadcastFlag) {
      super(theControlP5, theParent, theName, theDefaultValue, theX, theY, theWidth, theHeight);
  }
}

public class MyListBoxItem extends ListBoxItem {
      
  public MyListBoxItem(MyListBox listBox, String name, int theValue) {
    super(listBox, name, theValue);
  }
  
  public int getValue() {
    return value;
  }
  
  public String getName() {
    return name;
  }
}
