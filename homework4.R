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
# Gender inequality csv converts country names to ISO2 standard codes, world_map already has ISO2
gender_inequality <- gender_inequality %>%
  mutate(country_code = countrycode(country_name, "country.name", "iso2c"))

```



```{r}
# Merge data and calculate the difference in gender inequality index
#str() to view the data structure and get the content of the geojson file
#head() to view the first few rows of data
library(janitor)
world_data <- world_map %>%
  left_join(gender_inequality, by = c("ISO" = "country_code")) %>%
  clean_names() %>%
  distinct() %>%
  mutate(inequality_difference = abs(inequality_2019 - inequality_2010))
```


```{r}
# 将合并后的数据保存为 .geojson 文件
st_write(world_data, "world_gender_inequality.geojson")
```


```{r}
library(tmap)
tm_shape(world_data) +
  tm_polygons("inequality_difference", 
              alpha = 0.8, 
              title = "Gender Inequality Difference between 2010 and 2019",
              style = "cont", 
              palette = "Oranges", 
              border.col = "black", 
              popup.vars = "inequality_difference") +
tm_shape(world_data) +
  tm_borders() +
  tm_layout(legend.outside = TRUE)

```

