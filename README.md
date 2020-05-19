# SeitionEduline

#### 介绍
Eduline iOS端仓库

#### 分支说明
'master'：主分支。eduline删除支付宝/微信支付的原始代码.   
'develop'：开发分支。bug修复以及调整.  
'auth/'：授权分支分组。用于推送授权客户代码.     

命名规则：   
'master-项目名称'：同步eduline'master'代码，在'master'未更新到不可更新的大版本之前保持同步.     
'master-项目名称-dev'：改授权特征分支。用于修改属于该项目的特征内容，如替换素材等。   

合并原则：   
1、'develop'修改测试通过后合并到'master'.  
2、bug修复以及变更内容通过'master'同步到'master-项目名称'，再合并到'master-项目名称-dev'.  
3、不可跨分支合并，或者修改内容.  
