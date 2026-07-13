report 50264 "Cons. Finance Workplan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ConsFinanceWorkplan.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Workplan Activities"; "Workplan Activities")
        {
            RequestFilterFields = "Financial Year", "Procurement Workplan Code";

            column(DocumentDate; "Workplan Activities"."Activity Start Date") { }
            column(FinancialYearCode; "Workplan Activities"."Financial Year") { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationName2; CompanyInformation."Name 2") { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation.Address) { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }

            column(StrategicInitiativeCode; "Workplan Activities"."Account Type") { }
            column(Goal_ConsFinancialWPActivities; "Workplan Activities"."Activity Code") { }
            column(FocusArea_ConsFinancialWPActivities; "Workplan Activities"."Activity Description") { }
            column(Strategy_ConsFinancialWPActivities; "Workplan Activities"."Global Dimension 1 Code") { }
            column(Outcome_ConsFinancialWPActivities; "Workplan Activities"."Global Dimension 2 Code") { }
            column(Activity_ConsFinancialWPActivities; "Workplan Activities"."Procurement Method") { }
            column(KPI_ConsFinancialWPActivities; "Workplan Activities"."Procurement Workplan Code") { }
            column(OriginalStartDate_ConsFinancialWPActivities; "Workplan Activities"."Approved Quantity") { }
            column(OriginalEndDate_ConsFinancialWPActivities; "Workplan Activities"."Approved Total Cost") { }
            column(ActivityStatus_ConsFinancialWPActivities; "Workplan Activities"."Approved Unit Cost") { }
            column(Quantity_ConsFinancialWPActivities; "Workplan Activities".Quantity) { }

            column(PC_ConsFinancialWPActivities; "Workplan Activities"."Date to Transfer") { }
            column(ResponsibleEmployee_ConsFinancialWPActivities; "Workplan Activities"."Activity Start Date") { }
            column(ResponsibleEmployeeName_ConsFinancialWPActivities; "Workplan Activities"."Activity End  Date") { }
            column(Type_ConsFinancialWPActivities; "Workplan Activities".Type) { }
            column(AccountNo_ConsFinancialWPActivities; "Workplan Activities"."No.") { }
            column(Description_ConsFinancialWPActivities; "Workplan Activities".Description) { }
            column(TotalAmount_ConsFinancialWPActivities; "Workplan Activities"."Approved Quantity") { }
            column(StrategicGoalDescr_ConsFinancialWPActivities; "Workplan Activities"."Approved Total Cost") { }
            column(ReviewedStartDate_ConsFinancialWPActivities; "Workplan Activities"."Approved Quantity") { }
            column(ReviewedEndDate_ConsFinancialWPActivities; "Workplan Activities"."Board Approved") { }
            column(CapitalAssetsWorks_ConsFinancialWPActivities; "Workplan Activities".Status) { }
            column(OfficeGeneralSuppliesServ_ConsFinancialWPActivities; "Workplan Activities"."WorkPlan Status") { }
            column(Services_ConsFinancialWPActivities; "Workplan Activities"."Supplier Category") { }

            column(ActivityCode_ConsFinancialWPActivities; "Workplan Activities"."Activity Code") { }
            column(ActivityDescription_ConsFinancialWPActivities; "Workplan Activities"."Activity Description") { }
            column(SourceofFunds_ConsFinancialWPActivities; "Workplan Activities"."Source of Activity Fund") { }

            column(AccountType_ConsFinancialWPActivities; "Workplan Activities"."Account Type") { }

            column(UnitCost_ConsFinancialWPActivities; "Workplan Activities"."Unit Cost") { }
            column(Planned_Procurement_Quarter; "Planned Procurement Quarter") { }
            column(Unit_of_Measure; "Unit of Measure") { }
            column(Approved_Unit_Cost; "Approved Unit Cost") { }
            column(Approved_Total_Cost; "Approved Total Cost") { }
            column(Procurement_Method; "Procurement Method") { }
            column(Type; Type) { }

            column(Report_Grouping; "Report Grouping") { }

        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    var
        WorkPlanAct: Record "Workplan Activities";
        Item: Record Item;
    begin
        CompanyInformation.RESET;
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);

        WorkPlanAct.Reset();
        WorkPlanAct.SetFilter("Report Grouping", '=%1', '');
        if WorkPlanAct.Find('-') then begin
            repeat
                if WorkPlanAct."Report Grouping" = '' then begin
                    if WorkPlanAct.Type = WorkPlanAct.Type::Item then Begin
                        Item.RESET;
                        if Item.GET(WorkPlanAct."No.") then Begin
                            WorkPlanAct."Report Grouping" := Item."Inventory Posting Group";
                        end;
                    end;

                    if WorkPlanAct.Type = WorkPlanAct.Type::"G/L Account" then Begin
                        WorkPlanAct."Report Grouping" := WorkPlanAct."No.";
                    end;

                    if WorkPlanAct.Type = WorkPlanAct.Type::"Fixed Asset" then Begin
                        WorkPlanAct."Report Grouping" := WorkPlanAct."No.";
                    end;
                    WorkPlanAct.Modify();
                end;
            until WorkPlanAct.Next() = 0;
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
}

