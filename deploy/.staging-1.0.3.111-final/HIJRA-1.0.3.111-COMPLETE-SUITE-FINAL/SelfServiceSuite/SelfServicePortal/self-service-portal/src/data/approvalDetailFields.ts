import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'

/**
 * Header fields shown to APPROVERS on the approval detail screen, per module.
 *
 * UAT fail C: fuel (and other header-only documents) reached the approver with
 * no request details at all — the approval screen only rendered lines, and
 * fuel has none. These mirror the requester-side detail fields of each module
 * page, resolved against the same `payload` (raw Business Central row).
 */
export const approvalDetailFields: Record<string, DetailFieldConfig[]> = {
  fuelRequest: [
    { label: 'Request Type', paths: ['payload.RequisitionType', 'payload.Requisition_Type', 'payload.RequestType', 'payload.Request_Type'] },
    { label: 'Fuel Card No.', paths: ['payload.FuelCardNo', 'payload.Fuel_Card_No', 'payload.CardNo', 'payload.Card_No'] },
    { label: 'Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No', 'payload.VehicleNo', 'payload.Vehicle_No'] },
    { label: 'Fuel Dealer', paths: ['payload.VendorDealer', 'payload.Vendor_Dealer', 'payload.FuelDealer', 'payload.Fuel_Dealer'] },
    { label: 'Dealer Name', paths: ['payload.VendorName', 'payload.Vendor_Name'] },
    { label: 'Quantity (Litres)', paths: ['payload.QuantityofFuelLitres', 'payload.Quantity_of_Fuel_Litres', 'payload.Quantity'] },
    {
      label: 'Current Odometer (KM)',
      paths: ['payload.CurrentOdometer', 'payload.Initial_Odometer_Reading', 'payload.InitialOdometerReading'],
    },
    { label: 'Vehicle Fuel Rating', paths: ['payload.VehicleFuelRating'] },
    { label: 'Vehicle Previous Reading', paths: ['payload.VehicleCurrentReading'] },
    { label: 'Price per Litre', paths: ['payload.PriceLitre', 'payload.Price_Litre', 'payload.Price'], format: 'currency' },
    { label: 'Total Fuel Price', paths: ['payload.TotalPriceofFuel', 'payload.Total_Price_of_Fuel'], format: 'currency' },
    { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
    { label: 'Purpose', paths: ['payload.Description', 'payload.Purpose'] },
  ],
  maintenance: [
    { label: 'Request Type', paths: ['payload.maintenanceRequestTypeLabel', 'payload.RequestType', 'payload.RequisitionType', 'payload.Requisition_Type', 'payload.Type'] },
    { label: 'Vehicle No.', paths: ['payload.VehicleNo', 'payload.VehicleRegNo', 'payload.Vehicle_Reg_No'] },
    { label: 'FA Tag Number', paths: ['payload.FATagNumber', 'payload.FixedAssetNo', 'payload.Fixed_Asset_No'] },
    { label: 'Type of Maintenance', paths: ['payload.TypeofMaintenance', 'payload.Type_of_Maintenance'] },
    { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
    { label: 'Item / Service', paths: ['payload.Item'] },
    { label: 'Quantity', paths: ['payload.Quantity'] },
    { label: 'Priority', paths: ['payload.Priority'] },
    { label: 'Location', paths: ['payload.Location'] },
    { label: 'Current Odometer', paths: ['payload.CurrentOdometer'] },
    { label: 'Last Service Odometer', paths: ['payload.LastServiceOdometer'] },
    { label: 'Next Service KM', paths: ['payload.NextServiceKM', 'payload.Next_Service_KM'] },
    { label: 'Assigned Technician', paths: ['payload.AssignedTechnicianName', 'payload.AssignedTechnician'] },
    { label: 'Receipt Confirmed On', paths: ['payload.FAReceivedDate'], format: 'date' },
    { label: 'Receipt Remarks', paths: ['payload.ReceiptRemarks'] },
    { label: 'Description', paths: ['payload.IssueDescription', 'payload.MaintenanceDescription', 'payload.Description'] },
  ],
  transport: [
    { label: 'Request Type', paths: ['payload.transportRequestTypeLabel', 'payload.RequestType', 'payload.Request_Type', 'payload.VehicleType', 'payload.Vehicle_Type'] },
    { label: 'Trip Origin / Starting From', paths: ['payload.Commencement', 'payload.CommenceFrom', 'payload.StartingFrom'] },
    { label: 'Destination', paths: ['payload.To', 'payload.Destination'] },
    { label: 'Date of Trip', paths: ['payload.Date_of_Trip', 'payload.DateOfTrip'], format: 'date' },
    { label: 'Responsibility Center', paths: ['payload.Responsibility_Center', 'payload.ResponsibilityCenter', 'request.responsibleCenter'] },
    { label: 'No. of Days', paths: ['payload.No_of_Days_Requested', 'payload.NoOfDays'] },
    { label: 'No. of Passengers', paths: ['payload.No_Of_Passangers', 'payload.NoOfPassengers'] },
    { label: 'Purpose', paths: ['payload.Purpose_of_Trip', 'payload.PurposeOfTrip', 'payload.Purpose'] },
  ],
  training: [
    { label: 'Primary Training Course', paths: ['payload.trainingNeed', 'payload.TrainingCourseCode', 'payload.CourseTitle'] },
    { label: 'Additional Training(s)', paths: ['payload.otherTrainingName', 'payload.additionalTrainingNeeds'] },
    { label: 'Department', paths: ['payload.department', 'payload.DepartmentCode', 'request.departmentName'] },
    { label: 'Purpose / Expected Outcome', paths: ['payload.purpose', 'payload.Purpose'] },
    { label: 'Training Type', paths: ['payload.trainingType', 'payload.TrainingType'] },
    { label: 'Duration (Days)', paths: ['payload.durationDays', 'payload.DurationDays'] },
    { label: 'Target Group', paths: ['payload.targetGroup', 'payload.TargetGroup'] },
    { label: 'No. of Participants', paths: ['payload.participants', 'payload.NoOfParticipants'] },
    { label: 'Quarter', paths: ['payload.quarter', 'payload.Quarter'] },
    { label: 'Priority', paths: ['payload.priority', 'payload.Priority'] },
    { label: 'Vendor / Provider', paths: ['payload.vendor', 'payload.RecommendedVendor'] },
    { label: 'Estimated Budget', paths: ['payload.estimatedBudget', 'payload.EstimatedBudget'], format: 'currency' },
    { label: 'Training Period Start', paths: ['payload.periodStart', 'payload.TrainingStartDate'], format: 'date' },
    { label: 'Training Period End', paths: ['payload.periodEnd', 'payload.TrainingEndDate'], format: 'date' },
    { label: 'Remark', paths: ['payload.remark', 'payload.Remark'] },
  ],
  workTickets: [
    { label: 'Ticket No.', paths: ['request.requestNo', 'payload.TicketNo'] },
    { label: 'Traveler', paths: ['payload.travelerName', 'payload.travelerEmployeeNo'] },
    { label: 'Flight From', paths: ['payload.flightFrom'] },
    { label: 'Flight To', paths: ['payload.flightTo'] },
    { label: 'Departure Date', paths: ['payload.departureDate'], format: 'date' },
    { label: 'Return Date', paths: ['payload.returnDate'], format: 'date' },
    { label: 'Ticket Class', paths: ['payload.ticketClass'] },
    { label: 'Airline Preference', paths: ['payload.airlinePreference'] },
    { label: 'Booking Justification', paths: ['payload.justification'] },
    { label: 'Booking Confirmation No.', paths: ['payload.bookingConfirmationNo'] },
  ],
  purchaseRequisition: [
    { label: 'Needed By Date', paths: ['payload.Needed_By_Date', 'payload.OrderDate', 'payload.Order_Date', 'payload.Posting_Date'], format: 'date' },
    { label: 'Description', paths: ['payload.Posting_Description', 'payload.PostingDescription'] },
    { label: 'Department', paths: ['payload.RequestingDepartment', 'payload.Requesting_Department', 'payload.Shortcut_Dimension_1_Code', 'request.departmentName', 'request.departmentCode'] },
    { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
  ],
  storeRequisition: [
    { label: 'Requisition No.', paths: ['request.requestNo', 'payload.No'] },
    { label: 'Requested By', paths: ['request.makerName', 'payload.RequesterName', 'payload.RequesterID'] },
    { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo'] },
    { label: 'Job Title', paths: ['payload.RequesterJobTitle'] },
    { label: 'Branch / Place of Duty', paths: ['payload.RequesterPlaceOfDuty', 'payload.RequesterBranch'] },
    { label: 'Request Date', paths: ['payload.Requestdate', 'payload.RequestDate', 'request.createdAt'], format: 'date' },
    { label: 'Date Required', paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'], format: 'date' },
    { label: 'Issuing Store', paths: ['payload.IssuingStore', 'payload.Issuing_Store'] },
    { label: 'Description', paths: ['payload.RequestDescription', 'payload.Request_Description'] },
    { label: 'Justification', paths: ['payload.Justification'] },
    { label: 'Department / Cost Centre', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
    { label: 'Division', paths: ['payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code'] },
    { label: 'Responsibility Centre', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
    { label: 'Store Receipt No.', paths: ['payload.SRNNo', 'payload.SRN_No'] },
    { label: 'Issue Date', paths: ['payload.IssueDate', 'payload.Issue_Date'], format: 'date' },
    { label: 'Total Value', paths: ['payload.TotalAmount', 'request.amount'], format: 'currency' },
    { label: 'Status', paths: ['request.status'], format: 'status' },
  ],
  gatePass: [
    { label: 'Source', paths: ['payload.gatePassSourceLabel', 'payload.Linkto', 'payload.Link_to'] },
    { label: 'Source Document No.', paths: ['payload.TransferNo', 'payload.Transfer_No', 'payload.AssetTransferNo'] },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location', 'payload.AssetFromLocation'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location', 'payload.AssetToLocation'] },
    { label: 'Date Out', paths: ['payload.DateOut', 'payload.Date_Out', 'payload.DateCreated'], format: 'date' },
    { label: 'Description', paths: ['payload.Description'] },
    { label: 'Comment', paths: ['payload.Comment'] },
  ],
  transferOrder: [
    { label: 'From', paths: ['payload.TransferFromCode', 'payload.Transfer_from_Code', 'payload.FromCode'] },
    { label: 'To', paths: ['payload.TransferToCode', 'payload.Transfer_to_Code', 'payload.ToCode'] },
    { label: 'In-Transit Code', paths: ['payload.InTransitCode', 'payload.In_Transit_Code'] },
    { label: 'Posting Date', paths: ['payload.PostingDate', 'payload.Posting_Date'], format: 'date' },
    { label: 'Driver', paths: ['payload.DriverName', 'payload.Driver_Name'] },
    { label: 'Truck No.', paths: ['payload.TruckNo', 'payload.Truck_No'] },
  ],
  assetTransfer: [
    { label: 'Transfer Type', paths: ['payload.TransferType', 'payload.Transfer_Type', 'payload.TypeOfTransfer'] },
    {
      label: 'Asset No.',
      paths: [
        'payload.AssetToTransfer',
        'payload.Asset_to_Transfer',
        'payload.AssetNo',
        'payload.Asset_No',
        'payload.FixedAssetNo',
      ],
    },
    {
      label: 'From Employee',
      paths: [
        'payload.FromEmployeeName',
        'payload.FromResponsibleEmployee',
        'payload.From_Responsible_Employee',
        'payload.FromEmployeeNo',
        'payload.From_Employee_No',
      ],
    },
    {
      label: 'To Employee',
      paths: [
        'payload.ToEmployeeName',
        'payload.ToResponsibleEmployee',
        'payload.To_Responsible_Employee',
        'payload.ToEmployeeNo',
        'payload.To_Employee_No',
      ],
    },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
    { label: 'Reason', paths: ['payload.ReasonText', 'payload.Reason', 'payload.Description'] },
  ],
  imprest: [
    { label: 'Request No.', paths: ['request.requestNo'] },
    {
      label: 'Date Required',
      paths: [
        'payload.DateRequired',
        'payload.Date_Required',
        'payload.PaymentReleaseDate',
        'payload.Date',
        'request.createdAt',
      ],
      format: 'date',
    },
    { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
    {
      label: 'Travel Destination',
      paths: ['payload.TravelDestination', 'payload.Travel_Destination', 'payload.Destination'],
    },
    {
      label: 'Duration Date',
      paths: ['payload.DurationDate', 'payload.TravelDate', 'payload.ReturnDate'],
    },
    {
      label: 'Travel Date',
      paths: ['payload.TravelStartDate', 'payload.Travel_Start_Date', 'payload.TravelDate', 'payload.Travel_Date'],
      format: 'date',
    },
    {
      label: 'Return Date',
      paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate', 'payload.Return_Date'],
      format: 'date',
    },
    {
      label: 'Division',
      paths: ['payload.Division', 'payload.GlobalDimension1Code'],
    },
    {
      label: 'Department / District',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.DepartmentName',
        'payload.Department',
        'payload.ShortcutDimension2Code',
        'payload.District',
      ],
    },
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'] },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
    {
      label: 'Employee Account',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Remaining Unsettled',
      paths: [
        'payload.RemainingUnsettledAmount',
        'payload.RemainingNotSettledAmount',
        'payload.Balance',
        'payload.OutstandingBalance',
      ],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
  imprestSurrender: [
    { label: 'Surrender No.', paths: ['request.requestNo'] },
    {
      label: 'Surrender Date',
      paths: ['payload.SurrenderDate', 'payload.Surrender_Date', 'payload.DateCreated', 'request.createdAt'],
      format: 'date',
    },
    { label: 'Imprest No.', paths: ['payload.ImprestIssueDocNo', 'payload.Imprest_Issue_Doc_No', 'payload.ImprestNo'] },
    { label: 'Purpose', paths: ['payload.Purpose', 'request.title'] },
    {
      label: 'Duration Date',
      paths: ['payload.DurationDate', 'payload.TravelDate', 'payload.ReturnDate'],
    },
    {
      label: 'Travel Destination',
      paths: [
        'payload.TravelDestination',
        'payload.Travel_Destination',
        'payload.Destination',
        'payload.DestinationCode',
      ],
    },
    {
      label: 'Division',
      paths: ['payload.Division', 'payload.GlobalDimension1Code'],
    },
    {
      label: 'Department / District',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.DepartmentName',
        'payload.Department',
        'payload.ShortcutDimension2Code',
        'payload.District',
      ],
    },
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'],
    },
    { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title'] },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
    {
      label: 'Employee Account',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'],
    },
    {
      label: 'Imprest Amount',
      paths: ['payload.TotalNetAmount', 'payload.Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Outstanding Balance',
      paths: [
        'payload.Balance',
        'payload.BalanceLessThisEntry',
        'payload.Balance_Less_This_Entry',
        'payload.OutstandingBalance',
      ],
      format: 'currency',
    },
    {
      label: 'Cash Surrender Amount',
      paths: [
        'payload.CashSurrenderAmt',
        'payload.Cash_Surrender_Amt',
        'payload.CashSurrenderAmount',
      ],
      format: 'currency',
    },
    {
      label: 'Surrender Status',
      paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'],
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
  pettyCash: [
    { label: 'Request No.', paths: ['request.requestNo'] },
    {
      label: 'Needed By Date',
      paths: ['payload.Needed_By_Date', 'payload.Date', 'request.createdAt'],
      format: 'date',
    },
    { label: 'Description', paths: ['payload.PaymentNarration', 'payload.Payment_Narration', 'payload.Narration'] },
    {
      label: 'Division',
      paths: ['payload.Division', 'payload.GlobalDimension1Code'],
    },
    {
      label: 'Department / District',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.DepartmentName',
        'payload.Department',
        'payload.ShortcutDimension2Code',
        'payload.District',
      ],
    },
    {
      label: 'Branch',
      paths: [
        'payload.BranchName',
        'payload.Branch_Name',
        'payload.GlobalDimension2Code',
        'request.branchName',
        'request.branchCode',
      ],
    },
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.JobTitle'],
    },
    {
      label: 'Employee Account',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.TotalPaymentAmount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: ['payload.RejectionReason', 'payload.rejectionReason'],
    },
  ],
  staffClaim: [
    { label: 'Claim No.', paths: ['request.requestNo'] },
    { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date', 'request.createdAt'], format: 'date' },
    { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose'] },
    {
      label: 'Division',
      paths: ['payload.Division', 'payload.GlobalDimension1Code'],
    },
    {
      label: 'Department / District',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.DepartmentName',
        'payload.Department',
        'payload.ShortcutDimension2Code',
        'payload.District',
        'payload.GlobalDimension1Code',
      ],
    },
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    {
      label: 'Job Title',
      paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
    },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade'],
    },
    {
      label: 'Place of Duty',
      paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'],
    },
    {
      label: 'Employee Account',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
}
