package kr.co.yeonflix.purchaseHistory;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class PurchaseHistoryDTO {

	private int purchaseHistoryIdx, userIdx, reservationIdx, isPurchased;
}
