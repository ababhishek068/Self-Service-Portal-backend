xmlport 50003 "Export Workplan Activites"
{
    Direction = Export;
    Format = VariableText;
    // Format = VariableText;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(WorkplanActivities; "Workplan Activities")
            {
                fieldelement(AccountType; WorkplanActivities."Account Type") { }
                fieldelement(ActivityCode; WorkplanActivities."Activity Code") { }
                fieldelement(ActivityDescription; WorkplanActivities."Activity Description") { }
                fieldelement(AmounttoTransfer; WorkplanActivities."Amount to Transfer") { }
                fieldelement(CategorySubPlan; WorkplanActivities."Category Sub Plan") { }
                fieldelement(ConvertedtoBudgetby; WorkplanActivities."Converted to Budget by:") { }
                fieldelement(ConvertedtoGLBudget; WorkplanActivities."Converted to G/L Budget") { }
                fieldelement(CurrencyCode; WorkplanActivities."Currency Code") { }
                fieldelement(DatetoTransfer; WorkplanActivities."Date to Transfer") { }
                fieldelement(DimensionSetID; WorkplanActivities."Dimension Set ID") { }
                fieldelement(ExpenseCode; WorkplanActivities."Expense Code") { }
                fieldelement(GlobalDimension1Code; WorkplanActivities."Global Dimension 1 Code") { }
                fieldelement(GlobalDimension2Code; WorkplanActivities."Global Dimension 2 Code") { }
                fieldelement(No; WorkplanActivities."No.") { }
                fieldelement(PreferedVendorName; WorkplanActivities."Prefered Vendor Name") { }
                fieldelement(PreferedVendorNo; WorkplanActivities."Prefered Vendor No.") { }
                fieldelement(ProcurementMethod; WorkplanActivities."Procurement Method") { }
                fieldelement(ProcurementWorkplanCode; WorkplanActivities."Procurement Workplan Code") { }
                fieldelement(SourceofActivityFund; WorkplanActivities."Source of Activity Fund") { }
                fieldelement(TypeofPlan; WorkplanActivities."Type of Plan") { }
                fieldelement(TypeOfPurchase; WorkplanActivities."Type Of Purchase") { }
                fieldelement(UnitCost; WorkplanActivities."Unit Cost") { }
                fieldelement(UnitofMeasure; WorkplanActivities."Unit of Measure") { }
                fieldelement(Comments; WorkplanActivities.Comments) { }
                fieldelement(Description; WorkplanActivities.Description) { }
                fieldelement(Quantity; WorkplanActivities.Quantity) { }
                fieldelement(SystemId; WorkplanActivities.SystemId) { }
                fieldelement(Type; WorkplanActivities.Type) { }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
