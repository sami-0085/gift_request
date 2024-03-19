document.addEventListener("DOMContentLoaded", function() {
    // 要素の取得
    const questCard = document.getElementById('questCard');
    const showButton = document.getElementById('showButton');
    const hideButton = document.getElementById('hideButton');
  
    // 表示ボタンのクリックイベント
    showButton.addEventListener('click', function() {
      questCard.classList.remove('hidden'); // カードを表示
      showButton.classList.add('hidden'); // 表示ボタンを隠す
      hideButton.classList.remove('hidden'); // 閉じるボタンを表示
    });
  
    // 閉じるボタンのクリックイベント
    hideButton.addEventListener('click', function() {
      questCard.classList.add('hidden'); // カードを非表示
      showButton.classList.remove('hidden'); // 表示ボタンを表示
      hideButton.classList.add('hidden'); // 閉じるボタンを隠す
    });
  });
  