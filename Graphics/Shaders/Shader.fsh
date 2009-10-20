//
//  Shader.fsh
//  Graphics
//
//  Created by Lyss on 20/10/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
	gl_FragColor = colorVarying;
}
