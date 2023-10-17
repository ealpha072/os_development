#define VGA_ADDRESS 0xB8000
#define BLACK 0
#define GREEN 2
#define RED 4
#define YELLOW 14
#define WHITE 15

unsigned short *terminal_buffer;
unsigned int vga_index;

void clear_screen(void){
	int index = 0;
	//this clears the screen

	while(index < 80*25*2){
		terminal_buffer[index] = ' ';
		index +=2
	}
}

void print_string(){
	
}
