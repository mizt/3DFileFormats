#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {
    
    @autoreleasepool {
        
        int W = 256;
        int H = 144;
        
        NSMutableString *str = [NSMutableString stringWithString:@""];
        
        [str appendString:@"mtllib mesh.mtl\n"];
        [str appendString:@"usemtl mesh\n"];

        float aspect = H/(float)W;
       
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
                
                float vy1 = (y1/(float)(H-1))*2.0-1.0;
                float vy2 = (y1/(float)(H-1))*2.0-1.0;
                float vy3 = (y2/(float)(H-1))*2.0-1.0;
                float vy4 = (y2/(float)(H-1))*2.0-1.0;
                
                float vz1 = 0.0;
                float vz2 = 0.0;
                float vz3 = 0.0;
                float vz4 = 0.0;
                
                [str appendString:[NSString stringWithFormat:@"v %0.4f %0.4f %0.4f\n",vx1,vy1*aspect,vz1]];
                [str appendString:[NSString stringWithFormat:@"v %0.4f %0.4f %0.4f\n",vx2,vy2*aspect,vz2]];
                [str appendString:[NSString stringWithFormat:@"v %0.4f %0.4f %0.4f\n",vx3,vy3*aspect,vz3]];
                [str appendString:[NSString stringWithFormat:@"v %0.4f %0.4f %0.4f\n",vx4,vy4*aspect,vz4]];
                
            }
        }
        
        for(int i=0; i<H-1; i++) {
            for(int j=0; j<W-1; j++) {
                
                int x1 = j;
                int x2 = j+1;
                
                float vx1 = x1/(float)(W-1);
                float vx2 = x2/(float)(W-1);
                float vx3 = x2/(float)(W-1);
                float vx4 = x1/(float)(W-1);
                
                int y1 = i;
                int y2 = i+1;
                
                float vy1 = y1/(float)(H-1);
                float vy2 = y1/(float)(H-1);
                float vy3 = y2/(float)(H-1);
                float vy4 = y2/(float)(H-1);
                
                [str appendString:[NSString stringWithFormat:@"vt %0.4f %0.4f\n",vx1,vy1]];
                [str appendString:[NSString stringWithFormat:@"vt %0.4f %0.4f\n",vx2,vy2]];
                [str appendString:[NSString stringWithFormat:@"vt %0.4f %0.4f\n",vx3,vy3]];
                [str appendString:[NSString stringWithFormat:@"vt %0.4f %0.4f\n",vx4,vy4]];
            }
        }
        
        int o = 0;
        for(int i=0; i<H-1; i++) {
            for(int j=0; j<W-1; j++) {
                [str appendString:[NSString stringWithFormat:@"f %d/%d %d/%d %d/%d\n",o+1,o+1,o+2,o+2,o+4,o+4]];
                [str appendString:[NSString stringWithFormat:@"f %d/%d %d/%d %d/%d\n",o+2,o+2,o+3,o+3,o+4,o+4]];
                o+=4;
            }
        }
        
        [str writeToFile:@"./mesh.obj" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}