#import <stdio.h>
#import <substrate.h>
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>
#import <fstream>
#import <string.h>
#import <dirent.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <fcntl.h>
#import <sys/syscall.h>

//using namespace std;

int nest = 0;


%hook UIApplication
-(BOOL)canOpenURL:(id)arg1
{
    NSLog(@"canOpenURL");
    return NO;
}
%end

//---------------------------------------------//
struct dirent* readdir(DIR* dir);
%hookf(struct dirent*,readdir,DIR* dir)
{
    
    struct dirent* dire;
    
    while((dire = %orig(dir)) != NULL)
    {
        if (strcasecmp(dire->d_name,"User") == 0)
        {
            strcpy(dire->d_name,"System");
        }
        if (strcasecmp(dire->d_name,"pguntether") == 0)
        {
            strcpy(dire->d_name,"System");
        }
        if (strcasecmp(dire->d_name,"boot") == 0)
        {
            strcpy(dire->d_name,"System");
        }
        if (strcasecmp(dire->d_name,"lib") == 0)
        {
            strcpy(dire->d_name,"System");
        }
        if (strcasecmp(dire->d_name,"mnt") == 0)
        {
            strcpy(dire->d_name,"System");
        }
        if (strcasecmp(dire->d_name,"var") == 0)
        {
            strcpy(dire->d_name,"System");
        }

        return dire;
    }
    return %orig;
    
}

//---------------------------------------------//

DIR* __opendir2(const char *path, int buf);
%hookf(DIR *,__opendir2,const char *path,int buf)
{
    
    char* newpath = const_cast<char*>(path);
    
    
    if (strcasecmp(path,"/User") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/boot") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/lib") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/mnt") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/Applications/Cydia.app") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/private/var/lib") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    if (strcasecmp(path,"/private/var/stash") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    
    if (strcasecmp(path,"/private/var/mobile/Library/SBSettings/Themes") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    
    if (strcasecmp(path,"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist") == 0)
    {
        newpath[0] = 'a';
        return NULL;
    }
    
    DIR* dia = %orig(path,buf);
    return dia;
}

//---------------------------------------------//

int strcasecmp(const char *s1, const char *s2);
%hookf(int,strcasecmp,const char *s1, const char *s2)
{
    char* newcp = const_cast<char*>(s1);
    
    if (nest == 0)
    {
        nest += 1;
    }else{
        nest = 0;
        return %orig(s1,s2);
    }
    
    if (strcasecmp(".",s2) == 0)
    {
        strcpy(newcp,"AppStore.app");
    }
    
    return %orig(newcp,s2);
}
//---------------------------------------//
int system(const char *s1);
%hookf(int,system,const char *s1)
{
    return 0;
}

