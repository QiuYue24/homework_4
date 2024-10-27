library(tidyverse)
#Hi there
```{r}
library(dplyr)
library(sf)
library(readr)
library(countrycode)
library(here)
# 读取全球性别不平等数据
gender_inequality <- read_csv(here("data", "world_inequality_index_2010-2019.csv"))
# 读取世界地图数据（空间数据）
world_map <- st_read(here("data","World_Countries_(Generalized)_9029012925078512962.geojson"))
```
```{r}
#解决表格中空白和无效匹对的列
gender_inequality <- gender_inequality %>%
  filter(!is.na(country_name), 
         !country_name %in% c("Arab States", "East Asia and the Pacific", 
                              "Europe and Central Asia", "High human development",
                              "Latin America and the Caribbean", "Low human development", 
                              "Medium human development", "South Asia", 
                              "Sub-Saharan Africa", "Very high human development", 
                              "World", "总计")) %>%
  mutate(country_code = countrycode(country_name, "country.name", "iso2c"))


```


```{r}
# 将国家名称转换为 ISO3 标准代码
gender_inequality <- gender_inequality %>%
  mutate(country_code = countrycode(country_name, "country.name", "iso2c"))

```

```{r}
# 合并数据并计算性别不平等指数差异
#str()查看数据结构，得到geojson文件的内容
#head()查看前几行数据
world_data <- world_map %>%
  left_join(gender_inequality, by = c("ISO" = "country_code")) %>%
  mutate(inequality_difference = inequality_2019 - inequality_2010)
```


```{r}
# 将合并后的数据保存为 .geojson 文件
st_write(world_data, "world_gender_inequality.geojson")
```

