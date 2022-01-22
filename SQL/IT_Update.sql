/* IT Store Update
 * 
 * */

use IT;

/* Check Trigger 5,6:  Sale Price > Import Price*/
UPDATE PRODUCT SET ImportPrice=1300 where ProductTypeId = 3 AND IndexId = 1;

/* Check Trigger 7: Update Salary */
UPDATE EMPLOYEE SET Salary=41000 where Id = 4;

/* Check Trigger 9: Update ITEM's OrderId to Add/Remove Item To/From ORDERS */
Call AddItemToOrder(:_IndexId, :_OrderId, :_ItemType);
Call RemoveItemFromOrder(:_IndexId, :_ItemType); 

/* Check Trigger 10: Update Customer Balance*/
UPDATE CUSTOMER SET Balance=5000 where Id = 2;



/* StoreProcedure 11: Add AccessoriesType */
Call InsertAccessoriesType(:_Name, :_FunctionType, :_ManufactureId); 

/* StoreProcedure 11: Add roductType */
Call InsertProductType(:_Name, :_FunctionType, :_ManufactureId, :_ScreenSize, :_Processor, :_MemoryGB); 

/* StoreProcedure 12: Add Accessories, Product */
Call InsertItems(:_ItemType, :_TypeId, :_SalePrice, :_ImportPrice, :_BranchId, :_Quantity)

/* StoreProcedure 5: Insert Customer Checking Email Exists */
Call InsertCustomerAccount(:_Password, :_Address, :_Fullname, :_Email, :_Balance); 

/* StoreProcedure 2: Three parameter OrderId, IndexId, ItemType */
Call AddItemToOrder(:_IndexId, :_OrderId, :_ItemType);

/* StoreProcedure 2: Two parameter IndexId, ItemType */
Call RemoveItemFromOrder(:_IndexId, :_ItemType);

/* StoreProcedure 3: Confirm Order */
Call ConfirmOrder(:_OrderId); 

/* StoreProcedure 4: Assign Order To Employee */
Call AssignOrderToEmployee(:_OrderId, :_EmployeeId);



