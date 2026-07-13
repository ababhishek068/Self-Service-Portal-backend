Report 50052 "Inherent Risks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InherentRisks.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Risks; Risks)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Date Created";
            column(ReportForNavId_2; 2) { }
            column(Level_Risks; Risks.Level) { }
            column(riskDesc; riskDesc) { }
            column(riskIndicator; riskIndicator) { }
            column(riskRank; riskRank) { }
            column(isAction; isAction) { }
            column(Address_CompanyInformation; "Company information".Address) { }
            column(Address2_CompanyInformation; "Company information"."Address 2") { }
            column(City_CompanyInformation; "Company information".City) { }
            column(PhoneNo_CompanyInformation; "Company information"."Phone No.") { }
            column(Picture_CompanyInformation; "Company information".Picture) { }
            column(EMail_CompanyInformation; "Company information"."E-Mail") { }
            column(Name_CompanyInformation; "Company information".Name) { }
            column(website_CompanyInformation; "Company information"."Home Page") { }
            column(dateToday; dateToday) { }
            dataitem("Dimension Value"; "Dimension Value")
            {
                DataItemLink = Code = field(Department);
                DataItemTableView = sorting(Code) where("Dimension Code" = filter('DEPARTMENT'));
                RequestFilterFields = "Code";
                RequestFilterHeading = 'Department';
                column(ReportForNavId_1; 1) { }
                column(Name_DimensionValue; "Dimension Value".Name) { }
            }

            trigger OnAfterGetRecord()
            begin
                riskDesc := Risks."Risk Desc 1" + Risks."Risk Desc 2" + Risks."Risk Desc 3" + Risks."Risk Desc 4";
                riskIndicator := Risks."Indicator Desc 1" + Risks."Indicator Desc 2";
                if ((Risks.Level >= 0) and (Risks.Level <= 8)) then begin
                    riskRank := 'LOW';
                    isAction := 'No';
                end
                else
                    if ((Risks.Level >= 9) and (Risks.Level <= 14)) then begin
                        riskRank := 'MEDIUM';
                        isAction := 'Yes';
                    end
                    else
                        if ((Risks.Level >= 15) and (Risks.Level <= 25)) then begin
                            riskRank := 'HIGH';
                            isAction := 'Yes';
                        end;
            end;

            trigger OnPostDataItem()
            begin
                riskDesc := '';
                riskIndicator := '';
                riskRank := '';
                isAction := '';
            end;

            trigger OnPreDataItem()
            begin
                if "Company information".Get then
                    "Company information".CalcFields("Company information".Picture);
                dateToday := Today;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        "Company information": Record "Company Information";
        dateToday: Date;
        riskDesc: Text[1000];
        riskIndicator: Text[1000];
        riskRank: Text;
        isAction: Text;
}

