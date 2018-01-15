
Pod::Spec.new do |s|
    s.name         = 'LJContactManager'
    s.version      = '1.0.0'
    s.summary      = '获取通讯录所有信息'
    s.description  = '一行代码获取已排序和未排序的通讯录，一行代码添加号码至通讯录，操作通讯录的 UI'
    s.homepage     = 'https://github.com/leejayID/LJContactManager.git'
    s.license      = 'MIT'
    s.authors      = {'李健' => 'leejay_email@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/leejayID/LJContactManager.git', :tag => s.version}
    s.source_files = 'LJContactManager', 'LJContactManager/**/*.{h,m}'
    s.requires_arc = true
end
