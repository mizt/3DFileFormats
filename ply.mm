#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {
    
    @autoreleasepool {
        
        const unsigned short W = 256;
        const unsigned short H = 144;
        const float aspect = H/(float)W;

        const bool pc = true;

        const bool rgb = true;
        const unsigned char r = 0;
        const unsigned char g = 0;
        const unsigned char b = 255;
        
        const unsigned char num = 3;

        NSMutableString *header = [NSMutableString stringWithCapacity:0];
        [header appendString:@"ply\nformat binary_little_endian 1.0\n"];
        
        int elements = (pc)?(W*H):(W-1)*(H-1)*4;
        [header appendString:[NSString stringWithFormat:@"element vertex %d\n",elements]];
        [header appendString:@"property float x\nproperty float y\nproperty float z\n"];
        if(rgb) {
            [header appendString:@"property uchar red\nproperty uchar green\nproperty uchar blue\n"];
        }
        if(!pc) {
            int faces = (W-1)*(H-1)*2;
            [header appendString:[NSString stringWithFormat:@"element face %u\n",faces]];
            [header appendString:@"property list uchar int vertex_index\n"];
        }
        
        [header appendString:@"end_header\n"];
        
        NSMutableData *ply = [[NSMutableData alloc] init];
        NSData *bin = [header dataUsingEncoding:NSUTF8StringEncoding];
        [ply appendBytes:bin.bytes length:bin.length];
        
        if(pc) {
            
            for(int i=0; i<H; i++) {
                for(int j=0; j<W; j++) {
                    
                    float vx = (j/(float)(W-1))*2.0-1.0;
                    float vy = ((i/(float)(H-1))*2.0-1.0)*aspect;
                    float vz = 0.0;
                    
                    [ply appendBytes:(unsigned int *)(&vx) length:4];
                    [ply appendBytes:(unsigned int *)(&vy) length:4];
                    [ply appendBytes:(unsigned int *)(&vz) length:4];
                    if(rgb) {
                        [ply appendBytes:&r length:1];
                        [ply appendBytes:&g length:1];
                        [ply appendBytes:&b length:1];
                    }
                }
            }
        }
        else {
            
            for(int i=0; i<H-1; i++) {
                for(int j=0; j<W-1; j++) {
                    
                    int x1 = j;
                    int x2 = j+1;
                    
                    float vx1 = (x1/(float)(W-1))*2.0-1.0;
                    float vx2 = (x2/(float)(W-1))*2.0-1.0;
                    float vx3 = (x2/(float)(W-1))*2.0-1.0;
                    float vx4 = (x1/(float)(W-1))*2.0-1.0;
                    
                    int y1 = i;
                    int y2 = i+1;
                    
                    float vy1 = ((y1/(float)(H-1))*2.0-1.0)*aspect;
                    float vy2 = ((y1/(float)(H-1))*2.0-1.0)*aspect;
                    float vy3 = ((y2/(float)(H-1))*2.0-1.0)*aspect;
                    float vy4 = ((y2/(float)(H-1))*2.0-1.0)*aspect;
                    
                    float vz1 = 0.0;
                    float vz2 = 0.0;
                    float vz3 = 0.0;
                    float vz4 = 0.0;
                    
                    [ply appendBytes:(unsigned int *)(&vx1) length:4];
                    [ply appendBytes:(unsigned int *)(&vy1) length:4];
                    [ply appendBytes:(unsigned int *)(&vz1) length:4];
                    if(rgb) {
                        [ply appendBytes:&r length:1];
                        [ply appendBytes:&g length:1];
                        [ply appendBytes:&b length:1];
                    }
                    
                    [ply appendBytes:(unsigned int *)(&vx2) length:4];
                    [ply appendBytes:(unsigned int *)(&vy2) length:4];
                    [ply appendBytes:(unsigned int *)(&vz2) length:4];
                    if(rgb) {
                        [ply appendBytes:&r length:1];
                        [ply appendBytes:&g length:1];
                        [ply appendBytes:&b length:1];
                    }
                    
                    [ply appendBytes:(unsigned int *)(&vx3) length:4];
                    [ply appendBytes:(unsigned int *)(&vy3) length:4];
                    [ply appendBytes:(unsigned int *)(&vz3) length:4];
                    if(rgb) {
                        [ply appendBytes:&r length:1];
                        [ply appendBytes:&g length:1];
                        [ply appendBytes:&b length:1];
                    }
                    
                    [ply appendBytes:(unsigned int *)(&vx4) length:4];
                    [ply appendBytes:(unsigned int *)(&vy4) length:4];
                    [ply appendBytes:(unsigned int *)(&vz4) length:4];
                    if(rgb) {
                        [ply appendBytes:&r length:1];
                        [ply appendBytes:&g length:1];
                        [ply appendBytes:&b length:1];
                    }
                }
            }
            
            int o = 0;
            for(int i=0; i<H-1; i++) {
                for(int j=0; j<W-1; j++) {
                    
                    int a = o;
                    int b = o+1;
                    int c = o+3;
                    
                    [ply appendBytes:&num length:1];
                    [ply appendBytes:&a length:4];
                    [ply appendBytes:&b length:4];
                    [ply appendBytes:&c length:4];
                    
                    a = o+1;
                    b = o+2;
                    
                    [ply appendBytes:&num length:1];
                    [ply appendBytes:&a length:4];
                    [ply appendBytes:&b length:4];
                    [ply appendBytes:&c length:4];
                    
                    o+=4;
                }
            }
        }
        
        [ply writeToFile:@"./mesh.ply" atomically:YES];
    }
}