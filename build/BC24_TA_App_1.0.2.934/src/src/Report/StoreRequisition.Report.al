Report 50292 "Store Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StoreRequisition.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Store Requistion Header"; "Store Requistion Header")
        {
            RequestFilterFields = "No.";
            column(Requester_ID; "Requester ID") { }
            column(Employee_No; "Employee No") { }
            dataitem("Store Requistion Lines"; "Store Requistion Lines")
            {
                DataItemLink = "Requistion No" = field("No.");
                column(ReportForNavId_37; 37) { }
                column(CompInfo; info.Name) { }
                column(CompInformationPic; info.Picture) { }
                column(CompAddr; info.Address) { }
                column(CompPhone; info."Phone No.") { }
                column(CompFax; info."Fax No.") { }
                column(dept; DeptName) { }
                column(Reqdate; StoreH."Request date") { }
                column(UserId; UserId) { }
                column(pics; info.Picture) { }
                column(seq; seq) { }
                column(Store_Requistion_Lines__No__; "No.") { }
                column(Store_Requistion_Lines_Description; Description) { }
                column(LineNo_StoreRequistionLines; "Store Requistion Lines"."Line No.") { }
                column(Issue_Quantity; "Issue Quantity") { }
                column(Requested; "Store Requistion Lines"."Quantity Requested") { }
                column(Store_Requistion_Lines__Unit_of_Measure_; "Unit of Measure") { }
                column(Store_Requistion_Lines__Line_Amount_; "Line Amount") { }
                column(Store_Requistion_Lines__Unit_Cost_; "Unit Cost") { }
                column(Store_Requistion_Lines_Requistion_No; "Requistion No") { }
                column(QtyRequested; "Store Requistion Lines"."Quantity Requested") { }
                column(Quantity_Issued; "Quantity Issued") { }
                column(TotalAmount; "Quantity Issued" * "Unit Cost") { }

                trigger OnAfterGetRecord()
                begin

                    seq := seq + 1;
                    StoreH.get("Store Requistion Lines"."Requistion No");
                    dimVal.Reset;
                    dimVal.SetRange(dimVal.Code, StoreH."Shortcut Dimension 2 Code");
                    if dimVal.Find('-') then begin
                        DeptName := dimVal.Name;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    info.Get;
                    info.CalcFields(Picture);
                end;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        seq: Integer;
        dimVal: Record "Dimension Value";
        info: Record "Company Information";
        StoreH: Record "Store Requistion Header";
        DeptName: text[200];
}

