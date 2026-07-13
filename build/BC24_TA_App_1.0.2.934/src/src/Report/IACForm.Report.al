Report 50195 "IAC Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/IACForm.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(ReportForNavId_1; 1) { }

            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }

            column(COMPANYNAME; COMPANYNAME) { }
            column(ResponsibilityCenter_PurchaseHeader; "Purchase Header"."Responsibility Center") { }
            column(PurchaseRequisitionNo_PurchaseHeader; "Purchase Header"."Requisition No.") { }
            column(TenderRFQName_PurchaseHeader; "Purchase Header"."Tendor Number") { }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name") { }
            column(Order_Date; "Order Date") { }
            column(No_; "No.") { }
            column(RFQ_No_; "RFQ No.") { }
            column(Employee_No_; "Employee No.") { }
            dataitem("IAC Header"; "IAC Header")
            {
                DataItemLink = "LPO Number" = field("No.");
                DataItemTableView = sorting("No.", "LPO Number");
                column(ReportForNavId_14; 14) { }
                column(No_IACHeader; "IAC Header"."No.") { }
                column(Name_IACHeader; "IAC Header".Name) { }
                column(TelNo_IACHeader; "IAC Header"."Tel. No.") { }

                column(Contract_Amount; "Contract Amount") { }

                column(Delivery_Date; "Delivery Date") { }
                column(IDPassportNo_IACHeader; "IAC Header"."ID Passport No.") { }

                column(Delivery_Note_No_; "Delivery Note No.") { }
                column(PersonellNo_IACHeader; "IAC Header"."Personell No.") { }
                column(CommiteePosition_IACHeader; "IAC Header"."Commitee Position") { }
                column(Sign_IACHeader; "IAC Header".Sign) { }
                column(LPONumber_IACHeader; "IAC Header"."LPO Number") { }
                column(Name_of_Coopted_Member; "Name of Coopted Member") { }
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_2; 2) { }
                column(Type; "Purchase Line".Type) { }
                column(No; "Purchase Line"."No.") { }
                column(Description; "Purchase Line".Description) { }
                column(Quantity; "Purchase Line".Quantity) { }
                column(UnitofMeasure; "Purchase Line"."Unit of Measure") { }
                column(QuantityReceived; "Purchase Line"."Quantity Received") { }




                //column()
            }
        }
    }


    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        //Company Info
        fnCompanyInfo;
    end;


    var
        CompInfo: Record "Company Information";

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;
}

