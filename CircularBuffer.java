// a super simple circular buffer that holds


public class CircularBuffer {
    int[] array;
    int pointer;
    public int length = 0;

    public CircularBuffer (int bufferSize) {
        length = bufferSize;
        array = new int[bufferSize];

        pointer = 0;
    }


    
    public void put(int val) {  
        array[pointer] = val;
        //System.out.println("storing at idx " + pointer);
        pointer = (pointer + 1) % array.length;
    }
    
    
    
    public int get(int idx) {
      if (idx >= 0) {   
           
          if (idx >= length) idx = 0;
          int ptr = ( idx + pointer) % array.length ;

          //System.out.println("getting " + idx + " / " + ptr );
     
         return array[ptr];
      }  else {
       return 0; 
      }
      
    }
    
    
}
