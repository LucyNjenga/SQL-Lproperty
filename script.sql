USE [Lproperty]
GO
/****** Object:  View [dbo].[Agent_property]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Agent_property] as
Select Agent.AgentID,FirstName,LastName,Phone,count(property.AgentID) as NbrPropertyManaged
From Agent
INNER JOIN property ON Agent.AgentID = Property.AgentID
Group by Agent.AgentID,FirstName,LastName,Phone
Having count (property.AgentID)>=2
GO
/****** Object:  View [dbo].[Average_Rent]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Average_Rent] as
SELECT Agent.AgentID,FirstName,LastName,PropertyID,Street,Suburb,State,WeeklyRent
From Agent
 Inner Join property on Agent.AgentID=property.AgentID
WHERE  WeeklyRent <(select AVG(WeeklyRent) from property);
GO
/****** Object:  View [dbo].[Daisy_Hill]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Daisy_Hill] as
Select property.AgentID,Suburb,FirstName,LastName,Position,WeeklyRent
From Property
inner join Agent on Agent.AgentID=property.PropertyID
where WeeklyRent < 540 AND Suburb='Daisy Hill';
GO
/****** Object:  View [dbo].[High_InspectionCust]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[High_InspectionCust] as
SELECT Customer.CustomerID, FirstName, LastName, Phone, DOB
FROM Customer
INNER JOIN (
    SELECT TOP 1 CustomerID
    FROM Inspection
    GROUP BY CustomerID
    ORDER BY COUNT(*) DESC
) AS MostInspectedCustomers ON MostInspectedCustomers.CustomerID = Customer.CustomerID;
GO
/****** Object:  View [dbo].[Inspected_property]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Inspected_property] as
Select Property.propertyID,Street,Suburb,State,WeeklyRent,AgentID
from property 
Inner join Inspection on property.PropertyID=Inspection.PropertyID
where comments is NULL
GO
/****** Object:  View [dbo].[Not_inspected]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Not_inspected] as
SELECT property.PropertyID,Street,Suburb,state,WeeklyRent,AgentID
From property
left join Inspection on property.PropertyID=Inspection.PropertyID
where InspectionDate is null
GO
/****** Object:  View [dbo].[Not_inspectedB]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Not_inspectedB] as
Select property.PropertyID,Street,Suburb,state,WeeklyRent,AgentID
From Inspection
Right join property on Inspection.PropertyID =property.PropertyID
where InspectionDate is null
GO
/****** Object:  View [dbo].[Number_Inspection]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Number_Inspection] as
Select count (InspectionDate) as NumberofInspection
From Inspection
Where InspectionDate >= DATEADD(YEAR,-1,'2023/4/19');
GO
/****** Object:  View [dbo].[property_Charge]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[property_Charge] as
Select JobID,JobDescription,Charge,Street,Suburb,State,FirstName,LastName
From repairjob 
Inner join property on property.PropertyID=repairjob.PropertyID
inner join Agent on property.AgentID=Agent.AgentID
Where Charge between $1000 and $3000
GO
/****** Object:  View [dbo].[Repair_Cost]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Repair_Cost] as
Select property.PropertyID,Street,Suburb,State,Sum(repairjob.Charge)as Total_cost
from property
inner join repairjob on property.PropertyID=repairjob.PropertyID
Group by property.PropertyID,property.Street,property.Suburb,property.State
GO
/****** Object:  View [dbo].[Tradesmanjob]    Script Date: 8/31/2024 10:09:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[Tradesmanjob] as
Select tradesman.TradesmanID,FIRSTNAME,LASTNAME,PHONE,JobID,JobDescription,PropertyID,CompletedDate,Charge
From tradesman
left join repairjob on repairjob.TradesmanID=tradesman.TradesmanID;
GO
