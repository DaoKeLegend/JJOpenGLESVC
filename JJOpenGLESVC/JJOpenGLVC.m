//
//  JJOpenGLVC.m
//  JJOpenGLESVC
//
//  Created by 池田 on 2017/7/26.
//  Copyright © 2017年 Zebra. All rights reserved.
//

#import "JJOpenGLVC.h"

@interface JJOpenGLVC()

@property (nonatomic ,strong) EAGLContext* context;
@property (nonatomic ,strong) GLKBaseEffect* effect;

@end

@implementation JJOpenGLVC

#pragma mark - Override Base Function

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //配置上下文等
    [self beginConfig];
    
    //加载顶点着色器数据
    [self loadVertexArray];
    
    //添加纹理
    [self loadTexture];
}

#pragma mark - Object Private Function

//配置上下文等

- (void)beginConfig
{
    //新建OpenGLES 上下文
//    typedef NS_ENUM(NSUInteger, EAGLRenderingAPI)
//    {
//        kEAGLRenderingAPIOpenGLES1 = 1,
//        kEAGLRenderingAPIOpenGLES2 = 2,
//        kEAGLRenderingAPIOpenGLES3 = 3,
//    };
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.context];
}

//加载顶点着色器数据

- (void)loadVertexArray
{
    //顶点数据，前三个是顶点坐标，后面两个是纹理坐标  GLfloat 就是Float的别名
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    //顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
}

//添加纹理

- (void)loadTexture
{
    //纹理贴图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sea" ofType:@"jpg"];
    
    //GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    //着色器
    self.effect = [[GLKBaseEffect alloc] init];
    //打开纹理
    self.effect.texture2d0.enabled = GL_TRUE;
    //纹理的名称glGenTextures()
    self.effect.texture2d0.name = textureInfo.name;
}

#pragma mark - GLKViewDelegate

/**
 *  渲染场景代码, 在试图上开始着色并显示
 */

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //四个参数分别为RGBA
    glClearColor(0.7f, 0.2f, 1.0f, 1.0f);
    //清除32位色值
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.effect prepareToDraw];
    
    //着色的矩阵，第一个参数三角形模式，三个参数均为32位
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
