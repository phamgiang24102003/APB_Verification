# Compile RTL
-f rtl.f

# Compile TB
+incdir+../tb/agent
+incdir+../tb/env
+incdir+../tb/seq_lib
+incdir+../tb/test
+incdir+../tb/tb_top
-f tb.f
