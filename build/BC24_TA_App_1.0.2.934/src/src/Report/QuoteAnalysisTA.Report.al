
Report 52521 "Quote Analysis-TA"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Procurement/TAQuote Analysis.rdl';

    dataset
    {
        dataitem("Bid Analysis"; "Bid Analysis")
        {
            RequestFilterFields = "RFQ No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(Logo; CompInfo.Picture)
            {
            }
            column(Logo2; CompInfo.Picture)
            {
            }
            column(Watermark; CompInfo."Company Watermark")
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddress; CompInfo.Address)
            {
            }
            column(CompAddress2; CompInfo."Address 2")
            {
            }
            column(CompCity; CompInfo.City)
            {
            }
            column(CompPhone; CompInfo."Phone No.")
            {
            }
            column(CompCountry; CompInfo."Country/Region Code")
            {
            }
            column(RFQNo; "Bid Analysis"."RFQ No.")
            {
            }
            column(Type; "Bid Analysis".Status)
            {
            }
            column(No; "Bid Analysis"."Item No.")
            {
            }
            column(Description; "Bid Analysis".Description)
            {
            }
            column(UoM; "Bid Analysis"."Unit of Measure")
            {
            }
            column(Quantity; "Bid Analysis".Quantity)
            {
            }
            column(Mincode_RFQLines; "Bid Analysis"."Min code")
            {
            }
            column(text1; text1)
            {
            }
            column(Text2; Text2)
            {
            }
            column(Text3; Text3)
            {
            }
            column(Text4; Text4)
            {
            }
            column(MinutesText; MinutesText)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "RFQ No." = field("RFQ No."), "No." = field("Item No.");
                DataItemTableView = sorting("Unit Cost") order(ascending);
                column(ReportForNavId_8; 8)
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(Item; "Purchase Line".Description)
                {
                }
                column(Qty; "Purchase Line".Quantity)
                {
                }
                column(Cost; "Purchase Line"."Unit Cost")
                {
                }
                column(Total; "Purchase Line".Amount)
                {
                }
                column(SelectedText; SelectedText)
                {
                }
                column(IndicatorValue; IndicatorValue)
                {
                }
                column(Recomm; StrSubstNo(RecommendationText, SmallestBidVendor))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if VendorRec.Get("Purchase Line"."Buy-from Vendor No.") then
                        VendorName := VendorRec.Name;

                    SN := SN + 1;
                    if SN = 1 then
                        SelectedText := VendorName
                    else
                        SelectedText := '';

                    if SN = 1 then
                        IndicatorValue := 10
                    else if SN = 2 then
                        IndicatorValue := 50
                    else
                        IndicatorValue := 100;

                    //
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SN := 0;
                IndicatorValue := 0;

                RFQVendor.Reset;
                RFQVendor.SetRange(RFQVendor."Requisition Document No.", "Bid Analysis"."RFQ No.");
                if RFQVendor.FindFirst then begin
                    RFQVendor.CalcFields(Total, "Vendor Name");
                    SmallestBid := RFQVendor.Total;
                    SmallestBidVendor := RFQVendor."Vendor Name";
                    RFQVendor2.Reset();
                    RFQVendor2.SetRange("Requisition Document No.", RFQVendor."Requisition Document No.");
                    if RFQVendor2.Find('-') then begin
                        repeat
                            RFQVendor2.CalcFields(Total);
                            if RFQVendor2.Total < SmallestBid then begin
                                SmallestBid := RFQVendor2.Total;
                                SmallestBidVendor := RFQVendor2."Vendor Name";
                            end;
                            SmallestBid := SmallestBid;
                        until RFQVendor2.Next = 0;
                    end;
                end;
                // TODO: Add Minutes Setup
                // if MinutesSetup.Get("Bid Analysis"."Min code")then
                //   MinutesText:=MinutesSetup."Quote Description";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
        CompInfo.CalcFields("Company Watermark");
        // CompInfo.CalcFields(Picture2);

        // AdvancedFinanceSetup.Get;
        //AdvancedFinanceSetup.CALCFIELDS("Watermark Portrait");
    end;

    var
        VendorRec: Record Vendor;
        VendorName: Text;
        SN: Integer;
        SelectedText: Text;
        CompInfo: Record "Company Information";
        IndicatorValue: Integer;
        Total: Decimal;
        RFQVendor: Record "Quotation Request Vendors";
        SmallestBid: Decimal;
        SmallestBidVendor: Text;
        RFQVendor2: Record "Quotation Request Vendors";
        RecommendationText: label 'Based on Price, %1 has been Recommended on this Bid Analysis';
        // AdvancedFinanceSetup: Record UnknownRecord52121502;
        MinutesText: Text;
        // MinutesSetup: Record ;
        text1: label '. Approved Requisition for %1 ';
        Text2: label '. Price Analysis & Quotation';
        Text3: label '. The Prices are analyzed as follow;';
        Text4: label '. All the bidders are who participated are registered with';
}

