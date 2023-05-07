-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT cu.company_name,
	   CONCAT(e.first_name, ' ', e.last_name) as employee
FROM customers cu
	INNER JOIN orders o on o.customer_id = cu.customer_id
	INNER JOIN employees e on e.employee_id = o.employee_id
						   and e.city = 'London'
	INNER JOIN shippers s on s.shipper_id = o.ship_via
						  and s.company_name = 'United Package'
WHERE cu.city ='London'

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT pr.product_name,
	   pr.units_in_stock,
	   s.contact_name,
	   s.phone
FROM products pr
	INNER JOIN suppliers s on s.supplier_id = pr.supplier_id
	INNER JOIN categories ca on ca.category_id = pr.category_id
		                    and (ca.category_name = 'Dairy Products' or ca.category_name = 'Condiments')
WHERE pr.discontinued = 0 and pr.units_in_stock < 25
ORDER BY pr.units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT cu.company_name
FROM customers cu
	LEFT JOIN orders o on o.customer_id = cu.customer_id
WHERE o.order_id is NULL

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products
WHERE product_id = ANY (SELECT DISTINCT product_id FROM order_details WHERE quantity = 10)